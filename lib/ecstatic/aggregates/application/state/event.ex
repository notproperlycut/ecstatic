defmodule Ecstatic.Aggregates.Application.State.Event do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events

  def configure(%Events.ApplicationConfigured{} = application, %Events.SystemConfigured{} = system, %Events.ComponentConfigured{} = _component, events) do
    Enum.reduce(events, %State{}, fn {k, _v}, state ->
      event = %Events.EventConfigured{application_id: application.id, name: "#{system.name}.event.#{k}"}
      state |> State.merge(%State{events: [event]})
    end)
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add = new.events |> Enum.reject(fn n -> Enum.any?(existing.events, fn e -> e.name == n.name end) end)
    remove = existing.events |> Enum.reject(fn e -> Enum.any?(new.events, fn n -> n.name == e.name end) end) |> Enum.map(fn e -> %Events.EventRemoved{application_id: e.application_id, name: e.name} end)

    add ++ remove
  end

  def update(%State{} = state, %Events.EventConfigured{} = event) do
    %{state | events: [event | state.events |> Enum.reject(fn s -> s.name == event.name end)]}
  end

  def update(%State{} = state, %Events.EventRemoved{} = event) do
    %{state | events: state.events |> Enum.reject(fn s -> s.name == event.name end)}
  end
end

