defmodule Ecstatic.Aggregates.Application.State.Application do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Commands
  alias Ecstatic.Events

  def configure(%Commands.ConfigureApplication{name: name, systems: systems}) do
    with {:ok, application} <- Events.ApplicationConfigured.new(%{name: name}),
         {:ok, systems} <- State.System.configure(application, systems) do
      {:ok, State.merge(%State{applications: [application]}, systems)}
    end
  end

  def validate(%State{} = _state) do
    :ok
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add =
      new.applications
      |> Enum.reject(fn n -> Enum.any?(existing.applications, fn e -> e.name == n.name end) end)

    remove =
      existing.applications
      |> Enum.reject(fn e -> Enum.any?(new.applications, fn n -> n.name == e.name end) end)
      |> Enum.map(fn e -> %Events.ApplicationRemoved{name: e.name} end)

    {:ok, add ++ remove}
  end

  def update(%State{} = state, %Events.ApplicationConfigured{} = event) do
    %{state | applications: [event]}
  end
end
