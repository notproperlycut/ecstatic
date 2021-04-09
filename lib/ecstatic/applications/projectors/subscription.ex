defmodule Ecstatic.Applications.Projectors.Subscription do
  use Commanded.Projections.Ecto,
    application: Ecstatic.App,
    name: "Applications.Projectors.Subscription",
    consistency: :strong

  alias Ecstatic.Applications.Events.{
    ApplicationDestroyed,
    SubscriptionAdded,
    SubscriptionRemoved
  }

  alias Ecstatic.Applications.Projections.Subscription

  project(%SubscriptionAdded{} = subscription, fn multi ->
    Ecto.Multi.insert(multi, :create, %Subscription{
      name: subscription.name,
      application_id: subscription.application_id,
      belongs_to_component_type: subscription.belongs_to_component_type,
      payload: subscription.payload,
      handler: subscription.handler,
      trigger: subscription.trigger
    })
  end)

  project(%SubscriptionRemoved{} = subscription, fn multi ->
    subscription_query =
      from(c in Subscription,
        where: c.name == ^subscription.name and c.application_id == ^subscription.application_id
      )

    Ecto.Multi.delete_all(multi, :destroy, subscription_query)
  end)

  project(%ApplicationDestroyed{} = application, fn multi ->
    subscription_query = from(e in Subscription, where: e.application_id == ^application.id)

    Ecto.Multi.delete_all(multi, :destroy, subscription_query)
  end)
end
