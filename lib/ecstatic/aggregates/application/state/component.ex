defmodule Ecstatic.Aggregates.Application.State.Component do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events
  alias Ecstatic.Types

  def configure(
        %Events.ApplicationConfigured{} = application,
        %Events.SystemConfigured{} = system,
        components
      ) do
    Enum.reduce_while(components, {:ok, %State{}}, fn {k, v}, {:ok, state} ->
      with {:ok, name} <- Types.Names.Component.new(%{system: system.name, component: k}),
           {:ok, schema} <- Types.Schema.new(Map.from_struct(v.schema)),
           {:ok, component} <-
             Events.ComponentConfigured.new(%{
               application_id: application.id,
               name: to_string(name),
               schema: schema
             }),
           {:ok, commands} <- State.Command.configure(application, system, component, v.commands),
           {:ok, events} <- State.Event.configure(application, system, component, v.events),
           {:ok, subscribers} <-
             State.Subscriber.configure(application, system, component, v.subscribers) do
        state =
          state
          |> State.merge(%State{components: [component]})
          |> State.merge(commands)
          |> State.merge(events)
          |> State.merge(subscribers)

        {:cont, {:ok, state}}
      else
        error ->
          {:halt, error}
      end
    end)
  end

  def validate(%State{} = _state) do
    :ok
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add =
      new.components
      |> Enum.reject(fn n -> Enum.any?(existing.components, fn e -> e.name == n.name end) end)

    remove =
      existing.components
      |> Enum.reject(fn e -> Enum.any?(new.components, fn n -> n.name == e.name end) end)
      |> Enum.map(fn e ->
        Events.ComponentRemoved.new!(%{application_id: e.application_id, name: e.name})
      end)

    update =
      new.components
      |> Enum.filter(fn n -> Enum.any?(existing.components, fn e -> e.name == n.name end) end)
      |> Enum.reject(fn n -> Enum.any?(existing.components, fn e -> n == e end) end)

    schema_errors =
      update
      |> Enum.filter(fn n ->
        Enum.any?(existing.components, fn e -> e.name == n.name && e.schema != n.schema end)
      end)
      |> Enum.map(fn n -> "Cannot change schema of component #{n.name}" end)

    case schema_errors do
      [] ->
        {:ok, add ++ remove ++ update}

      _ ->
        {:error, schema_errors}
    end
  end

  def update(%State{} = state, %Events.ComponentConfigured{} = event) do
    %{
      state
      | components: [event | state.components |> Enum.reject(fn s -> s.name == event.name end)]
    }
  end

  def update(%State{} = state, %Events.ComponentRemoved{} = event) do
    %{state | components: state.components |> Enum.reject(fn s -> s.name == event.name end)}
  end
end
