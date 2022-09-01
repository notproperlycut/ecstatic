defmodule Ecstatic.Aggregates.Application.State.Event do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events
  alias Ecstatic.Types

  def configure(
        %Events.ApplicationConfigured{} = application,
        %Events.SystemConfigured{} = system,
        %Events.ComponentConfigured{} = component,
        events
      ) do
    Enum.reduce_while(events, {:ok, %State{}}, fn {k, v}, {:ok, state} ->
      with {:ok, name} <- Types.Name.long(system.name, :event, k),
           {:ok, schema} <- Types.Schema.new(Map.from_struct(v.schema)),
           {:ok, handler} <- Types.Handler.new(Map.from_struct(v.handler)),
           {:ok, event} <-
             Events.EventConfigured.new(%{
               application: application.name,
               component: component.name,
               name: to_string(name),
               handler: handler,
               schema: schema
             }) do
        state = state |> State.merge(%State{events: [event]})
        {:cont, {:ok, state}}
      else
        error ->
          {:halt, error}
      end
    end)
  end

  def validate(%State{} = state) do
    case state.events
         |> Enum.map(fn c -> c.name end)
         |> (&(&1 -- Enum.uniq(&1))).()
         |> Enum.uniq() do
      [] ->
        :ok

      d ->
        {:error, "Application definition contains duplicate event names: #{Enum.join(d, ", ")}"}
    end
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add =
      new.events
      |> Enum.reject(fn n -> Enum.any?(existing.events, fn e -> e.name == n.name end) end)

    remove =
      existing.events
      |> Enum.reject(fn e -> Enum.any?(new.events, fn n -> n.name == e.name end) end)
      |> Enum.map(fn e ->
        Events.EventRemoved.new!(%{application: e.application, name: e.name})
      end)

    update =
      new.events
      |> Enum.filter(fn n -> Enum.any?(existing.events, fn e -> e.name == n.name end) end)
      |> Enum.reject(fn n -> Enum.any?(existing.events, fn e -> n == e end) end)

    schema_errors =
      update
      |> Enum.filter(fn n ->
        Enum.any?(existing.events, fn e -> e.name == n.name && e.schema != n.schema end)
      end)
      |> Enum.map(fn n -> "Cannot change schema of event #{n.name}" end)

    case schema_errors do
      [] ->
        {:ok, add ++ remove ++ update}

      _ ->
        {:error, schema_errors}
    end
  end

  def update(%State{} = state, %Events.EventConfigured{} = event) do
    %{state | events: [event | state.events |> Enum.reject(fn s -> s.name == event.name end)]}
  end

  def update(%State{} = state, %Events.EventRemoved{} = event) do
    %{state | events: state.events |> Enum.reject(fn s -> s.name == event.name end)}
  end
end
