defmodule Ecstatic.Applications.Projectors.Command do
  use Commanded.Projections.Ecto,
    application: Ecstatic.App,
    name: "Applications.Projectors.Command",
    consistency: :strong

  alias Ecstatic.Applications.Events.{
    ApplicationDestroyed,
    CommandAdded,
    CommandRemoved
  }

  alias Ecstatic.Applications.Projections.Command

  project(%CommandAdded{} = command, fn multi ->
    Ecto.Multi.insert(multi, :create, %Command{
      name: command.name,
      application_id: command.application_id,
      belongs_to_component_type: command.belongs_to_component_type,
      schema: command.schema,
      handler: command.handler
    })
  end)

  project(%CommandRemoved{} = command, fn multi ->
    command_query =
      from(c in Command,
        where: c.name == ^command.name and c.application_id == ^command.application_id
      )

    Ecto.Multi.delete_all(multi, :destroy, command_query)
  end)

  project(%ApplicationDestroyed{} = application, fn multi ->
    command_query = from(c in Command, where: c.application_id == ^application.id)
    Ecto.Multi.delete_all(multi, :destroy, command_query)
  end)
end
