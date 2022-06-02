defmodule Ecstatic.Aggregates.Application.State do
  defstruct [
    applications: [],
    systems: []
  ]

  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events

  def configure(%State{} = state, command) do
    {applications, systems} = State.Application.configure(command)

    applications = State.Application.add_remove(state.applications, applications)
    systems = State.System.add_remove(state.systems, systems)

    {:ok, applications ++ systems}
  end

  def remove(%State{} = state) do
    applications = State.Application.add_remove(state.applications, [])
    systems = State.System.add_remove(state.systems, [])

    {:ok, applications ++ systems}
  end

  def update(%State{} = state, %Events.ApplicationConfigured{} = event) do
    %{state | applications: State.Application.update(state.applications, event)}
  end

  def update(%State{} = state, %Events.SystemConfigured{} = event) do
    %{state | systems: State.System.update(state.systems, event)}
  end

  def update(%State{} = state, %Events.SystemRemoved{} = event) do
    %{state | systems: State.System.update(state.systems, event)}
  end
end
