defmodule Ecstatic.Commanded.Projectors.System do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded.Application,
    repo: Ecstatic.Commanded.Repo,
    name: "Projectors.System",
    consistency: :strong

  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Projections.System

  project(%Events.SystemConfigured{} = event, _metadata, fn multi ->
    system = %System{
      application: event.application,
      name: event.name
    }

    Ecto.Multi.insert(multi, :system, system, on_conflict: :nothing)
  end)

  project(%Events.SystemRemoved{} = event, _metadata, fn multi ->
    query =
      from(c in System, where: c.application == ^event.application and c.name == ^event.name)

    Ecto.Multi.delete_all(multi, :system, query)
  end)
end
