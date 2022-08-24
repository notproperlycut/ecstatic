defmodule Ecstatic.Projectors.System do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded,
    repo: Ecstatic.Repo,
    name: "Projectors.System",
    consistency: :strong

  alias Ecstatic.Events
  alias Ecstatic.Projections.System

  project(%Events.SystemConfigured{} = event, _metadata, fn multi ->
    system = %System{
      application_id: event.application_id,
      name: event.name
    }

    Ecto.Multi.insert(multi, :system, system, on_conflict: :nothing)
  end)

  project(%Events.SystemRemoved{} = event, _metadata, fn multi ->
    query =
      from(c in System, where: c.application_id == ^event.application_id and c.name == ^event.name)

    Ecto.Multi.delete_all(multi, :system, query)
  end)
end
