defmodule Ecstatic.Applications.Aggregates.Subscription do
  alias Ecstatic.Applications.Aggregates.Application

  alias Ecstatic.Applications.Events.{
    SubscriptionAdded,
    SubscriptionRemoved,
    Handler
  }

  alias Ecstatic.Applications.Aggregates.Validators

  def add(application, system, component_type, add_subscriptions) do
    add_subscriptions
    |> Enum.map(&add_subscription(application, system, component_type, &1))
    |> List.flatten()
  end

  defp add_subscription(application, system, component_type, add_subscription) do
    %SubscriptionAdded{
      id: UUID.uuid4(),
      name: add_subscription.name,
      trigger: add_subscription.trigger,
      payload: add_subscription.payload,
      handler: Handler.new(add_subscription.handler),
      application_id: application.id,
      system_id: system.id,
      component_type_id: component_type.id
    }
  end

  def remove(application, component_type) do
    application.subscriptions
    |> Enum.filter(&(&1.component_type_id == component_type.id))
    |> Enum.map(&remove_subscription(&1))
    |> List.flatten()
  end

  defp remove_subscription(subscription) do
    %SubscriptionRemoved{id: subscription.id}
  end

  def apply(application, %SubscriptionAdded{} = event) do
    %Application{application | subscriptions: [event | application.subscriptions]}
  end

  def apply(application, %SubscriptionRemoved{} = event) do
    subscriptions =
      Enum.reject(application.subscriptions, fn s ->
        s.id == event.id
      end)

    %Application{application | subscriptions: subscriptions}
  end

  def apply(%Application{} = application, _event) do
    application
  end

  def validate(application) do
    [
      Validators.Names.validate_all_unique(application.subscriptions),
      Enum.map(application.subscriptions, &validate_subscription(&1, application))
    ]
    |> Validators.collate_errors()
  end

  def validate_subscription(subscription, application) do
    [
      Validators.Names.validate_format(subscription, :subscription),
      Validators.Names.validate_share_system(
        subscription,
        :component_type_id,
        application,
        :component_types
      ),
      Validators.Handler.validate(subscription),
      validate_trigger(subscription, application),
      validate_payload(subscription, application)
    ]
  end

  defp validate_trigger(subscription, application) do
    Validators.Entities.validate_exists_by_name(subscription.trigger, application, [
      :component_types,
      :events,
      :families
    ])
    |> Validators.prepend_message("Trigger for subscription #{subscription.name}, ")
  end

  defp validate_payload(subscription, application) do
    String.split(subscription.payload, " ")
    |> Enum.map(&Validators.Entities.validate_exists_by_name(&1, application, :component_types))
    |> Validators.collate_errors()
    |> Validators.prepend_message("Payload for subscription #{subscription.name}, ")
  end
end
