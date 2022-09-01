defmodule Ecstatic.Projectors.Subscriber do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded,
    repo: Ecstatic.Repo,
    name: "Projectors.Subscriber",
    consistency: :strong

  alias Ecstatic.Events
  alias Ecstatic.Projections.Subscriber

  project(%Events.SubscriberConfigured{} = event, _metadata, fn multi ->
    subscriber = %Subscriber{
      application: event.application,
      component: event.component,
      name: event.name,
      trigger: event.trigger,
      handler: event.handler
    }

    Ecto.Multi.insert(multi, :subscriber, subscriber,
      on_conflict: [set: [trigger: event.trigger, handler: event.handler]],
      conflict_target: [:application, :name]
    )
  end)

  project(%Events.SubscriberRemoved{} = event, _metadata, fn multi ->
    query =
      from(c in Subscriber,
        where: c.application == ^event.application and c.name == ^event.name
      )

    Ecto.Multi.delete_all(multi, :subscriber, query)
  end)
end
