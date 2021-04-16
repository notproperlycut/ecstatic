defmodule Ecstatic.Applications.Projectors.Event do
  use Commanded.Projections.Ecto,
    application: Ecstatic.App,
    name: "Applications.Projectors.Event",
    consistency: :strong

  alias Ecstatic.Applications.Events.{
    ApplicationDestroyed,
    EventAdded,
    EventRemoved
  }

  alias Ecstatic.Applications.Projections.Event

  project(%EventAdded{} = event, fn multi ->
    Ecto.Multi.insert(multi, :create, %Event{
      id: event.id,
      name: event.name,
      application_id: event.application_id,
      system_id: event.system_id,
      component_type_id: event.component_type_id,
      schema: event.schema,
      handler: event.handler
    })
  end)

  project(%EventRemoved{} = event, fn multi ->
    event_query = from(c in Event, where: c.id == ^event.id)

    Ecto.Multi.delete_all(multi, :destroy, event_query)
  end)

  project(%ApplicationDestroyed{} = application, fn multi ->
    event_query = from(e in Event, where: e.application_id == ^application.id)
    Ecto.Multi.delete_all(multi, :destroy, event_query)
  end)
end
