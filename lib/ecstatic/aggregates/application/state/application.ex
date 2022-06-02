defmodule Ecstatic.Aggregates.Application.State.Application do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Commands
  alias Ecstatic.Events

  def configure(%Commands.ConfigureApplication{id: id, systems: systems}) do
    application = %Events.ApplicationConfigured{id: id}
    systems = State.System.configure(application, systems)

    {[application], systems}
  end

  def add_remove(existing, new) do
    add = new |> Enum.reject(fn n -> Enum.any?(existing, fn e -> e.id == n.id end) end)
    remove = existing |> Enum.reject(fn e -> Enum.any?(new, fn n -> n.id == e.id end) end) |> Enum.map(fn e -> %Events.ApplicationRemoved{id: e.id} end)

    add ++ remove
  end

  def update(_applications, %Events.ApplicationConfigured{} = event) do
    [event]
  end
end
