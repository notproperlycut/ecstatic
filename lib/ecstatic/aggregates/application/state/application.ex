defmodule Ecstatic.Aggregates.Application.State.Application do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Commands
  alias Ecstatic.Events

  def configure(%Commands.ConfigureApplication{id: id, systems: systems}) do
    with {:ok, application} <- Events.ApplicationConfigured.new(%{id: id}),
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
      |> Enum.reject(fn n -> Enum.any?(existing.applications, fn e -> e.id == n.id end) end)

    remove =
      existing.applications
      |> Enum.reject(fn e -> Enum.any?(new.applications, fn n -> n.id == e.id end) end)
      |> Enum.map(fn e -> %Events.ApplicationRemoved{id: e.id} end)

    add ++ remove
  end

  def update(%State{} = state, %Events.ApplicationConfigured{} = event) do
    %{state | applications: [event]}
  end
end
