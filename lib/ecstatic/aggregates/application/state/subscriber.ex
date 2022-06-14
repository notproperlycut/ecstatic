defmodule Ecstatic.Aggregates.Application.State.Subscriber do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events
  alias Ecstatic.Types.Names

  def configure(
        %Events.ApplicationConfigured{} = application,
        %Events.SystemConfigured{} = system,
        %Events.ComponentConfigured{} = _component,
        subscribers
      ) do
    Enum.reduce_while(subscribers, {:ok, %State{}}, fn {k, _v}, {:ok, state} ->
      with {:ok, name} <- Names.Subscriber.new(%{system: system.name, subscriber: k}),
           subscriber <- %Events.SubscriberConfigured{
             application_id: application.id,
             name: to_string(name)
           } do
        state = state |> State.merge(%State{subscribers: [subscriber]})
        {:cont, {:ok, state}}
      else
        error ->
          {:halt, error}
      end
    end)
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add =
      new.subscribers
      |> Enum.reject(fn n -> Enum.any?(existing.subscribers, fn e -> e.name == n.name end) end)

    remove =
      existing.subscribers
      |> Enum.reject(fn e -> Enum.any?(new.subscribers, fn n -> n.name == e.name end) end)
      |> Enum.map(fn e ->
        %Events.SubscriberRemoved{application_id: e.application_id, name: e.name}
      end)

    add ++ remove
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
