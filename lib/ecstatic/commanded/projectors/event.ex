defmodule Ecstatic.Commanded.Projectors.Event do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded.Application,
    repo: Ecstatic.Commanded.Repo,
    name: "Projectors.Event",
    consistency: :strong

  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Projections.Event

  project(%Events.Event.Added{application: application, configuration: configuration}, _metadata, fn multi ->
    event = %Event{
      application: application,
      component: configuration.component,
      name: configuration.name,
      schema: configuration.schema,
      handler: configuration.handler
    }

    Ecto.Multi.insert(multi, :event, event)
  end)

  project(%Events.Event.Updated{application: application, configuration: configuration}, _metadata, fn multi ->
    query =
      from(c in Event, where: c.application == ^application and c.name == ^configuration.name)

    event = %Event{
      application: application,
      component: configuration.component,
      name: configuration.name,
      schema: configuration.schema,
      handler: configuration.handler
    }

    Ecto.Multi.update(multi, :event, query, set: event)
  end)

  project(%Events.Event.Removed{application: application, configuration: configuration}, _metadata, fn multi ->
    query =
      from(c in Event, where: c.application == ^application and c.name == ^configuration.name)

    Ecto.Multi.delete_all(multi, :event, query)
  end)
end
