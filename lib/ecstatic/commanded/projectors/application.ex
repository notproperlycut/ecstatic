defmodule Ecstatic.Commanded.Projectors.Application do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded.Application,
    repo: Ecstatic.Commanded.Repo,
    name: "Projectors.Application",
    consistency: :strong

  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Projections.Application

  project(%Events.Application.Added{name: name}, _metadata, fn multi ->
    application = %Application{
      name: name
    }

    Ecto.Multi.insert(multi, :application, application)
  end)

  project(%Events.Application.Updated{name: name}, _metadata, fn multi ->
    query = from(a in Application, where: a.name == ^name)

    application = %Application{
      name: name
    }

    Ecto.Multi.update(multi, :application, query, set: application)
  end)

  project(%Events.Application.Removed{name: name}, _metadata, fn multi ->
    query = from(a in Application, where: a.name == ^name)
    Ecto.Multi.delete_all(multi, :application, query)
  end)
end
