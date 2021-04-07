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
      application_id: event.application_id,
      name: event.name,
      schema: event.schema,
      belongs_to_component_type: event.belongs_to_component_type,
      handler: event.handler
    })
  end)

  project(%EventRemoved{} = event, fn multi ->
    event_query =
      from(c in Event, where: c.name == ^event.name and c.application_id == ^event.application_id)

    Ecto.Multi.delete_all(multi, :destroy, event_query)
  end)

  project(%ApplicationDestroyed{} = application, fn multi ->
    event_query = from(e in Event, where: e.application_id == ^application.id)
    Ecto.Multi.delete_all(multi, :destroy, event_query)
  end)
end
