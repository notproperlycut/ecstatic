defmodule Ecstatic.Applications.Aggregates.Subscription do
  alias Ecstatic.Applications.Aggregates.Application

  alias Ecstatic.Applications.Commands.{
    AddSystem,
    RemoveSystem
  }

  alias Ecstatic.Applications.Events.{
    SubscriptionAdded,
    SubscriptionRemoved,
    Handler
  }

  alias Ecstatic.Applications.Aggregates.Validators

  def add_system(%{id: application_id}, %AddSystem{} = add_system) do
    add_system.component_types
    |> Enum.flat_map(fn ct ->
      Enum.map(ct.subscriptions, fn s ->
        %SubscriptionAdded{
          application_id: application_id,
          name: s.name,
          trigger: s.trigger,
          payload: s.payload,
          handler: Handler.new(s.handler),
          belongs_to_component_type: ct.name
        }
      end)
    end)
  end

  def remove_system(
        %{
          id: application_id,
          component_types: component_types,
          subscriptions: subscriptions
        },
        %RemoveSystem{name: name}
      ) do
    component_types
    |> Enum.filter(fn ct -> ct.belongs_to_system == name end)
    |> Enum.flat_map(fn ct ->
      Enum.filter(subscriptions, fn s -> s.belongs_to_component_type == ct.name end)
    end)
    |> Enum.map(fn s ->
      %SubscriptionRemoved{application_id: application_id, name: s.name}
    end)
  end

  def apply(application, %SubscriptionAdded{} = subscription) do
    %Application{application | subscriptions: [subscription | application.subscriptions]}
  end

  def apply(application, %SubscriptionRemoved{} = subscription) do
    subscriptions =
      Enum.reject(application.subscriptions, fn s ->
        s.name == subscription.name
      end)

    %Application{application | subscriptions: subscriptions}
  end

  def validate(%{subscriptions: subscriptions} = application) do
    [
      Validators.Names.validate_all_unique(subscriptions),
      Enum.map(subscriptions, &validate(&1, application))
    ]
    |> Validators.collate_errors()
  end

  def validate(subscription, application) do
    [
      Validators.Names.validate_format(subscription, :subscription),
      Validators.Names.validate_share_system(subscription, :belongs_to_component_type),
      Validators.Entities.validate_relation(
        subscription,
        :belongs_to_component_type,
        application,
        :component_types
      ),
      Validators.Handler.validate(subscription),
      validate_trigger(subscription, application),
      validate_payload(subscription, application)
    ]
  end

  defp validate_trigger(subscription, application) do
    Validators.Entities.validate_exists(subscription.trigger, application, [
      :component_types,
      :events,
      :families
    ])
    |> Validators.prepend_message("Trigger for subscription #{subscription.name}, ")
  end

  defp validate_payload(subscription, application) do
    String.split(subscription.payload, " ")
    |> Enum.map(&Validators.Entities.validate_exists(&1, application, :component_types))
    |> Validators.collate_errors()
    |> Validators.prepend_message("Payload for subscription #{subscription.name}, ")
  end
end
