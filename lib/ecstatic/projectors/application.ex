defmodule Ecstatic.Projectors.Application do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded,
    repo: Ecstatic.Repo,
    name: "Projectors.Application",
    consistency: :strong

  alias Ecstatic.Events
  alias Ecstatic.Projections.Application

  project(%Events.ApplicationConfigured{} = event, _metadata, fn multi ->
    application = %Application{
      id: event.id
    }

    Ecto.Multi.insert(multi, :application, application, on_conflict: :nothing)
  end)

  project(%Events.ApplicationRemoved{} = event, _metadata, fn multi ->
    query = from(c in Application, where: c.id == ^event.id)
    Ecto.Multi.delete_all(multi, :application, query)
  end)
end
