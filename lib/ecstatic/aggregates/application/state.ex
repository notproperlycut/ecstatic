defmodule Ecstatic.Aggregates.Application.State do
  defstruct [
    applications: [],
    systems: [],
    families: [],
    components: []
  ]

  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events

  def configure(%State{} = state, command) do
    new_state = State.Application.configure(command)

    applications = State.Application.add_remove(state, new_state)
    systems = State.System.add_remove(state, new_state)
    families = State.Family.add_remove(state, new_state)
    components = State.Component.add_remove(state, new_state)

    {:ok, applications ++ systems ++ families ++ components}
  end

  def remove(%State{} = state) do
    empty = %State{}

    applications = State.Application.add_remove(state, empty)
    systems = State.System.add_remove(state, empty)
    families = State.Family.add_remove(state, empty)
    components = State.Component.add_remove(state, empty)

    {:ok, applications ++ systems ++ families ++ components}
  end

  def merge(%State{} = state1, %State{} = state2) do
    %State{
      applications: state1.applications ++ state2.applications,
      systems: state1.systems ++ state2.systems,
      families: state1.families ++ state2.families,
      components: state1.components ++ state2.components,
    }
  end

  def update(%State{} = state, %Events.ApplicationConfigured{} = event) do
    State.Application.update(state, event)
  end

  def update(%State{} = state, %Events.SystemConfigured{} = event) do
    State.System.update(state, event)
  end

  def update(%State{} = state, %Events.SystemRemoved{} = event) do
    State.System.update(state, event)
  end

  def update(%State{} = state, %Events.FamilyConfigured{} = event) do
    State.Family.update(state, event)
  end

  def update(%State{} = state, %Events.FamilyRemoved{} = event) do
    State.Family.update(state, event)
  end

  def update(%State{} = state, %Events.ComponentConfigured{} = event) do
    State.Component.update(state, event)
  end

  def update(%State{} = state, %Events.ComponentRemoved{} = event) do
    State.Component.update(state, event)
  end
end
