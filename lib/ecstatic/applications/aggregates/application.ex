defmodule Ecstatic.Applications.Aggregates.Application do
  alias Ecstatic.Applications.Aggregates.Validators

  defstruct [
    :id,
    :state,
    systems: [],
    commands: [],
    component_types: [],
    events: [],
    families: [],
    subscriptions: []
  ]

  alias Commanded.Aggregate.Multi

  alias Ecstatic.Applications.Aggregates.{
    Application,
    Command,
    ComponentType,
    Event,
    Family,
    Subscription,
    System
  }

  alias Ecstatic.Applications.Commands.{
    CreateApplication,
    DestroyApplication,
    AddSystem,
    RemoveSystem
  }

  alias Ecstatic.Applications.Events.{
    ApplicationCreated,
    ApplicationDestroyed,
    CommandAdded,
    CommandRemoved,
    ComponentTypeAdded,
    ComponentTypeRemoved,
    EventAdded,
    EventRemoved,
    FamilyAdded,
    FamilyRemoved,
    SubscriptionAdded,
    SubscriptionRemoved,
    SystemAdded,
    SystemRemoved
  }

  # Public command API

  def execute(%Application{state: :destroyed}, _) do
    {:error, :application_destroyed}
  end

  def execute(%Application{id: nil}, %CreateApplication{
        id: id,
        api_secret: api_secret
      }) do
    %ApplicationCreated{id: id, api_secret: api_secret}
  end

  def execute(%Application{}, %CreateApplication{}) do
    {:error, :application_already_created}
  end

  def execute(%Application{id: nil}, _) do
    {:error, :application_not_found}
  end

  def execute(%Application{}, %DestroyApplication{id: id}) do
    %ApplicationDestroyed{id: id}
  end

  def execute(%Application{} = application, %AddSystem{} = add_system) do
    # Care with the ordering of these operations, so that names in the definition
    # can resolve into IDs

    application
    |> Multi.new()
    |> Multi.execute(&System.add_system(&1, add_system))
    |> Multi.execute(&ComponentType.add_system(&1, add_system))
    |> Multi.execute(&Command.add_system(&1, add_system))
    |> Multi.execute(&Event.add_system(&1, add_system))
    |> Multi.execute(&Subscription.add_system(&1, add_system))
    |> Multi.execute(&Family.add_system(&1, add_system))
    |> Multi.execute(&validate(&1))
  end

  def execute(%Application{} = application, %RemoveSystem{} = remove_system) do
    application
    |> Multi.new()
    |> Multi.execute(&System.remove_system(&1, remove_system))
    |> Multi.execute(&ComponentType.remove_system(&1, remove_system))
    |> Multi.execute(&Command.remove_system(&1, remove_system))
    |> Multi.execute(&Event.remove_system(&1, remove_system))
    |> Multi.execute(&Subscription.remove_system(&1, remove_system))
    |> Multi.execute(&Family.remove_system(&1, remove_system))
    |> Multi.execute(&validate(&1))
  end

  # State mutators

  def apply(%Application{} = application, %ApplicationCreated{id: id}) do
    %Application{application | id: id, state: :created}
  end

  def apply(%Application{} = application, %ApplicationDestroyed{}) do
    %Application{application | state: :destroyed}
  end

  def apply(%Application{} = application, %CommandAdded{} = event),
    do: Command.apply(application, event)

  def apply(%Application{} = application, %CommandRemoved{} = event),
    do: Command.apply(application, event)

  def apply(%Application{} = application, %ComponentTypeAdded{} = event),
    do: ComponentType.apply(application, event)

  def apply(%Application{} = application, %ComponentTypeRemoved{} = event),
    do: ComponentType.apply(application, event)

  def apply(%Application{} = application, %EventAdded{} = event),
    do: Event.apply(application, event)

  def apply(%Application{} = application, %EventRemoved{} = event),
    do: Event.apply(application, event)

  def apply(%Application{} = application, %FamilyAdded{} = event),
    do: Family.apply(application, event)

  def apply(%Application{} = application, %FamilyRemoved{} = event),
    do: Family.apply(application, event)

  def apply(%Application{} = application, %SubscriptionAdded{} = event),
    do: Subscription.apply(application, event)

  def apply(%Application{} = application, %SubscriptionRemoved{} = event),
    do: Subscription.apply(application, event)

  def apply(%Application{} = application, %SystemAdded{} = event),
    do: System.apply(application, event)

  def apply(%Application{} = application, %SystemRemoved{} = event),
    do: System.apply(application, event)

  defp validate(application) do
      [Command, ComponentType, Event, Family, Subscription, System]
      |> Enum.map(fn mod -> mod.validate(application) end)
      |> Validators.collate_errors()
  end
end
