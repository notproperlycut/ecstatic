defmodule Ecstatic.Applications.Aggregates.Application do
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
    ApplicationDestroyed
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
    application
    |> Multi.new()
    |> Multi.execute(&System.add(&1, add_system))
    |> Multi.execute(&validate(&1))
  end

  def execute(%Application{} = application, %RemoveSystem{} = remove_system) do
    application
    |> Multi.new()
    |> Multi.execute(&System.remove(&1, remove_system))
    |> Multi.execute(&validate(&1))
  end

  # State mutators
  def apply(%Application{} = application, %ApplicationCreated{id: id} = event) do
    %Application{application | id: id, state: :created}
    |> System.apply(event)
  end

  def apply(%Application{} = application, %ApplicationDestroyed{} = event) do
    %Application{application | state: :destroyed}
    |> System.apply(event)
  end

  def apply(%Application{} = application, event) do
    application
    |> System.apply(event)
  end

  # Validation
  defp validate(application) do
    System.validate(application)
  end
end
