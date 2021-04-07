defmodule Ecstatic.Applications.Projectors.ComponentType do
  use Commanded.Projections.Ecto,
    application: Ecstatic.App,
    name: "Applications.Projectors.ComponentType",
    consistency: :strong

  alias Ecstatic.Applications.Events.{
    ApplicationDestroyed,
    ComponentTypeAdded,
    ComponentTypeRemoved
  }

  alias Ecstatic.Applications.Projections.ComponentType

  project(%ComponentTypeAdded{} = component_type, fn multi ->
    Ecto.Multi.insert(multi, :create, %ComponentType{
      application_id: component_type.application_id,
      name: component_type.name,
      schema: component_type.schema,
      belongs_to_system: component_type.belongs_to_system
    })
  end)

  project(%ComponentTypeRemoved{} = component_type, fn multi ->
    component_type_query =
      from(c in ComponentType,
        where:
          c.name == ^component_type.name and c.application_id == ^component_type.application_id
      )

    Ecto.Multi.delete_all(multi, :destroy, component_type_query)
  end)

  project(%ApplicationDestroyed{} = application, fn multi ->
    component_type_query =
      from(c in ComponentType, where: c.application_id == ^application.id)

    Ecto.Multi.delete_all(multi, :destroy, component_type_query)
  end)
end
