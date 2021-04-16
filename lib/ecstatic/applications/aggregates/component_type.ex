defmodule Ecstatic.Applications.Aggregates.ComponentType do
  alias Ecstatic.Applications.Aggregates.{
    Application,
    Command,
    Event,
    Subscription
  }

  alias Ecstatic.Applications.Events.{
    ComponentTypeAdded,
    ComponentTypeRemoved
  }

  alias Ecstatic.Applications.Aggregates.Validators

  def add(application, system, add_component_types) do
    add_component_types
    |> Enum.map(&add_component_type(application, system, &1))
    |> List.flatten()
  end

  defp add_component_type(application, system, add_component_type) do
    component_type = %ComponentTypeAdded{
      id: UUID.uuid4(),
      name: add_component_type.name,
      schema: add_component_type.schema,
      application_id: application.id,
      system_id: system.id
    }

    [
      component_type,
      Command.add(application, system, component_type, add_component_type.commands),
      Event.add(application, system, component_type, add_component_type.events),
      Subscription.add(application, system, component_type, add_component_type.subscriptions)
    ]
    |> List.flatten()
  end

  def remove(application, system) do
    application.component_types
    |> Enum.filter(&(&1.system_id == system.id))
    |> Enum.map(&remove_component_type(application, &1))
    |> List.flatten()
  end

  defp remove_component_type(application, component_type) do
    [
      %ComponentTypeRemoved{id: component_type.id},
      Command.remove(application, component_type),
      Event.remove(application, component_type),
      Subscription.remove(application, component_type)
    ]
    |> List.flatten()
  end

  def apply(application, %ComponentTypeAdded{} = event) do
    %Application{application | component_types: [event | application.component_types]}
    |> Command.apply(event)
    |> Event.apply(event)
    |> Subscription.apply(event)
  end

  def apply(application, %ComponentTypeRemoved{} = event) do
    component_types =
      Enum.reject(application.component_types, fn s ->
        s.id == event.id
      end)

    %Application{application | component_types: component_types}
    |> Command.apply(event)
    |> Event.apply(event)
    |> Subscription.apply(event)
  end

  def apply(%Application{} = application, event) do
    application
    |> Command.apply(event)
    |> Event.apply(event)
    |> Subscription.apply(event)
  end

  def validate(application) do
    [
      Validators.Names.validate_all_unique(application.component_types),
      Enum.map(application.component_types, &validate_component_type(&1, application)),
      Command.validate(application),
      Event.validate(application),
      Subscription.validate(application)
    ]
    |> Validators.collate_errors()
  end

  def validate_component_type(component_type, application) do
    [
      Validators.Names.validate_format(component_type, :component_type),
      Validators.Names.validate_share_system(component_type, :system_id, application, :systems),
      Validators.JsonSchema.validate(component_type)
    ]
  end
end
