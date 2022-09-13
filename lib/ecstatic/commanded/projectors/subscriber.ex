defmodule Ecstatic.Commanded.Projectors.Subscriber do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded.Application,
    repo: Ecstatic.Commanded.Repo,
    name: "Projectors.Subscriber",
    consistency: :strong

  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Projections.Subscriber

  project(%Events.Subscriber.Added{application: application, configuration: configuration}, _metadata, fn multi ->
    subscriber = %Subscriber{
      application: application,
      component: configuration.component,
      name: configuration.name,
      trigger: configuration.trigger,
      handler: configuration.handler
    }

    Ecto.Multi.insert(multi, :subscriber, subscriber)
  end)

  project(%Events.Subscriber.Updated{application: application, configuration: configuration}, _metadata, fn multi ->
    query =
      from(c in Subscriber,
        where: c.application == ^application and c.name == ^configuration.name
      )

    subscriber = %Subscriber{
      application: application,
      component: configuration.component,
      name: configuration.name,
      trigger: configuration.trigger,
      handler: configuration.handler
    }

    Ecto.Multi.update(multi, :subscriber, query, set: subscriber)
  end)

  project(%Events.Subscriber.Removed{application: application, configuration: configuration}, _metadata, fn multi ->
    query =
      from(c in Subscriber,
        where: c.application == ^application and c.name == ^configuration.name
      )

    Ecto.Multi.delete_all(multi, :subscriber, query)
  end)
end
