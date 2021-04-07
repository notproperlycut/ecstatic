defmodule Ecstatic.Applications.Projectors.Application do
  use Commanded.Projections.Ecto,
    application: Ecstatic.App,
    name: "Applications.Projectors.Application",
    consistency: :strong

  alias Ecstatic.Applications.Events.{
    ApplicationCreated,
    ApplicationDestroyed
  }

  alias Ecstatic.Applications.Projections.Application

  project(%ApplicationCreated{} = application, fn multi ->
    Ecto.Multi.insert(multi, :create, %Application{
      id: application.id,
      api_secret: application.api_secret
    })
  end)

  project(%ApplicationDestroyed{id: id}, fn multi ->
    # TODO: presumably faster to delete one row
    application_query = from(e in Application, where: e.id == ^id)
    Ecto.Multi.delete_all(multi, :destroy, application_query)
  end)
end
