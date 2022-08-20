defmodule Ecstatic.Aggregates.Application.State.Subscriber do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events
  alias Ecstatic.Types

  def configure(
        %Events.ApplicationConfigured{} = application,
        %Events.SystemConfigured{} = system,
        %Events.ComponentConfigured{} = component,
        subscribers
      ) do
    Enum.reduce_while(subscribers, {:ok, %State{}}, fn {k, v}, {:ok, state} ->
      with {:ok, name} <- Types.Names.Subscriber.new(%{system: system.name, subscriber: k}),
           {:ok, trigger} <- Types.Trigger.new(Map.from_struct(v.trigger)),
           {:ok, handler} <- Types.Handler.new(Map.from_struct(v.handler)),
           {:ok, subscriber} <-
             Events.SubscriberConfigured.new(%{
               application_id: application.id,
               component_name: component.name,
               name: to_string(name),
               handler: handler,
               trigger: trigger
             }) do
        state = state |> State.merge(%State{subscribers: [subscriber]})
        {:cont, {:ok, state}}
      else
        error ->
          {:halt, error}
      end
    end)
  end

  def validate(%State{} = state) do
    case state.subscribers
         |> Enum.map(fn c -> c.name end)
         |> (&(&1 -- Enum.uniq(&1))).()
         |> Enum.uniq() do
      [] ->
        :ok

      d ->
        {:error,
         "Application definition contains duplicate subscriber names: #{Enum.join(d, ", ")}"}
    end
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add =
      new.subscribers
      |> Enum.reject(fn n -> Enum.any?(existing.subscribers, fn e -> e.name == n.name end) end)

    remove =
      existing.subscribers
      |> Enum.reject(fn e -> Enum.any?(new.subscribers, fn n -> n.name == e.name end) end)
      |> Enum.map(fn e ->
        Events.SubscriberRemoved.new!(%{application_id: e.application_id, name: e.name})
      end)

    update =
      new.subscribers
      |> Enum.filter(fn n -> Enum.any?(existing.subscribers, fn e -> e.name == n.name end) end)
      |> Enum.reject(fn n -> Enum.any?(existing.subscribers, fn e -> n == e end) end)

    {:ok, add ++ remove ++ update}
  end

  def update(%State{} = state, %Events.SubscriberConfigured{} = event) do
    %{
      state
      | subscribers: [event | state.subscribers |> Enum.reject(fn s -> s.name == event.name end)]
    }
  end

  def update(%State{} = state, %Events.SubscriberRemoved{} = event) do
    %{state | subscribers: state.subscribers |> Enum.reject(fn s -> s.name == event.name end)}
  end
end
