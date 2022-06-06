defmodule Ecstatic.Aggregates.Application.State.System do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events

  def configure(%Events.ApplicationConfigured{} = application, systems) do
    Enum.reduce(systems, %State{}, fn {k, v}, state ->
      system = %Events.SystemConfigured{application_id: application.id, name: "#{k}"}
      families = State.Family.configure(application, system, v.families)
      components = State.Component.configure(application, system, v.components)

      state |> State.merge(%State{systems: [system]}) |> State.merge(families) |> State.merge(components)
    end)
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add = new.systems |> Enum.reject(fn n -> Enum.any?(existing.systems, fn e -> e.name == n.name end) end)
    remove = existing.systems |> Enum.reject(fn e -> Enum.any?(new.systems, fn n -> n.name == e.name end) end) |> Enum.map(fn e -> %Events.SystemRemoved{application_id: e.application_id, name: e.name} end)

    add ++ remove
  end

  def update(%State{} = state, %Events.SystemConfigured{} = event) do
    %{state | systems: [event | state.systems |> Enum.reject(fn s -> s.name == event.name end)]}
  end

  def update(%State{} = state, %Events.SystemRemoved{} = event) do
    %{state | systems: state.systems |> Enum.reject(fn s -> s.name == event.name end)}
  end
end
