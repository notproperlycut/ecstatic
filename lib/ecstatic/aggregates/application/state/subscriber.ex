defmodule Ecstatic.Aggregates.Application.State.Subscriber do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events

  def configure(%Events.ApplicationConfigured{} = application, %Events.SystemConfigured{} = system, %Events.ComponentConfigured{} = _component, subscribers) do
    Enum.reduce(subscribers, %State{}, fn {k, _v}, state ->
      subscriber = %Events.SubscriberConfigured{application_id: application.id, name: "#{system.name}.subscriber.#{k}"}
      state |> State.merge(%State{subscribers: [subscriber]})
    end)
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add = new.subscribers |> Enum.reject(fn n -> Enum.any?(existing.subscribers, fn e -> e.name == n.name end) end)
    remove = existing.subscribers |> Enum.reject(fn e -> Enum.any?(new.subscribers, fn n -> n.name == e.name end) end) |> Enum.map(fn e -> %Events.SubscriberRemoved{application_id: e.application_id, name: e.name} end)

    add ++ remove
  end

  def update(%State{} = state, %Events.SubscriberConfigured{} = event) do
    %{state | subscribers: [event | state.subscribers |> Enum.reject(fn s -> s.name == event.name end)]}
  end

  def update(%State{} = state, %Events.SubscriberRemoved{} = event) do
    %{state | subscribers: state.subscribers |> Enum.reject(fn s -> s.name == event.name end)}
  end
end

