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
      id: subscription.id,
      name: subscription.name,
      application_id: subscription.application_id,
      system_id: subscription.system_id,
      component_type_id: subscription.component_type_id,
      payload: subscription.payload,
      handler: subscription.handler,
      trigger: subscription.trigger
    })
  end)

  project(%SubscriptionRemoved{} = subscription, fn multi ->
    subscription_query =
      from(c in Subscription,
        where: c.id == ^subscription.id
      )

    Ecto.Multi.delete_all(multi, :destroy, subscription_query)
  end)

  project(%ApplicationDestroyed{} = application, fn multi ->
    subscription_query = from(e in Subscription, where: e.application_id == ^application.id)

    Ecto.Multi.delete_all(multi, :destroy, subscription_query)
  end)
end
