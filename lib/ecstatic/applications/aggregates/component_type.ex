defmodule Ecstatic.Applications.Aggregates.ComponentType do
  alias Ecstatic.Applications.Aggregates.Application

  alias Ecstatic.Applications.Commands.{
    AddSystem,
    RemoveSystem
  }

  alias Ecstatic.Applications.Events.{
    ComponentTypeAdded,
    ComponentTypeRemoved
  }

  alias Ecstatic.Applications.Aggregates.Validators

  def add_system(%{id: application_id}, %AddSystem{} = add_system) do
    add_system.component_types
    |> Enum.map(fn ct ->
      %ComponentTypeAdded{
        application_id: application_id,
        name: ct.name,
        schema: ct.schema,
        belongs_to_system: add_system.name
      }
    end)
  end

  def remove_system(
        %{id: application_id, component_types: component_types},
        %RemoveSystem{name: name}
      ) do
    component_types
    |> Enum.filter(fn ct -> ct.belongs_to_system == name end)
    |> Enum.map(fn ct ->
      %ComponentTypeRemoved{application_id: application_id, name: ct.name}
    end)
  end

  def apply(application, %ComponentTypeAdded{} = component_type) do
    %Application{application | component_types: [component_type | application.component_types]}
  end

  def apply(application, %ComponentTypeRemoved{} = component_type) do
    component_types =
      Enum.reject(application.component_types, fn s ->
        s.name == component_type.name
      end)

    %Application{application | component_types: component_types}
  end

  def validate(%{component_types: component_types} = application) do
    [
      Validators.Names.validate_all_unique(component_types),
      Enum.map(component_types, &validate(&1, application))
    ]
    |> Validators.collate_errors()
  end

  def validate(component_type, application) do
    [
      Validators.Names.validate_format(component_type, :component_type),
      Validators.Names.validate_share_system(component_type, :belongs_to_system),
      Validators.Entities.validate_relation(
        component_type,
        :belongs_to_system,
        application,
        :systems
      ),
      Validators.JsonSchema.validate(component_type)
    ]
  end
end
