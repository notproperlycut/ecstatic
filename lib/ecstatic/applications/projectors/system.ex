defmodule Ecstatic.Applications.Projectors.System do
  use Commanded.Projections.Ecto,
    application: Ecstatic.App,
    name: "Applications.Projectors.System",
    consistency: :strong

  alias Ecstatic.Applications.Events.{
    ApplicationDestroyed,
    SystemAdded,
    SystemRemoved
  }

  alias Ecstatic.Applications.Projections.System

  project(%SystemAdded{} = system, fn multi ->
    Ecto.Multi.insert(multi, :create, %System{
      application_id: system.application_id,
      name: system.name
    })
  end)

  project(%SystemRemoved{} = system, fn multi ->
    system_query =
      from(s in System,
        where: s.name == ^system.name and s.application_id == ^system.application_id
      )

    Ecto.Multi.delete_all(multi, :destroy, system_query)
  end)

  project(%ApplicationDestroyed{} = application, fn multi ->
    system_query = from(s in System, where: s.application_id == ^application.id)
    Ecto.Multi.delete_all(multi, :destroy, system_query)
  end)
end
