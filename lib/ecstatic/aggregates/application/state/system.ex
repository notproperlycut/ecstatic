defmodule Ecstatic.Aggregates.Application.State.System do
  alias Ecstatic.Events

  def configure(%Events.ApplicationConfigured{id: id}, systems) do
    Map.keys(systems) |> Enum.map(fn k -> %Events.SystemConfigured{application_id: id, name: "system.#{k}"} end)
  end

  def add_remove(existing, new) do
    add = new |> Enum.reject(fn n -> Enum.any?(existing, fn e -> e.name == n.name end) end)
    remove = existing |> Enum.reject(fn e -> Enum.any?(new, fn n -> n.name == e.name end) end) |> Enum.map(fn e -> %Events.SystemRemoved{application_id: e.application_id, name: e.name} end)

    add ++ remove
  end

  def update(systems, %Events.SystemConfigured{} = event) do
    [event | systems |> Enum.reject(fn s -> s.name == event.name end)]
  end

  def update(systems, %Events.SystemRemoved{} = event) do
    systems |> Enum.reject(fn s -> s.name == event.name end)
  end
end
