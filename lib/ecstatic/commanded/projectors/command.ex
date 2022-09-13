defmodule Ecstatic.Commanded.Projectors.Command do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded.Application,
    repo: Ecstatic.Commanded.Repo,
    name: "Projectors.Command",
    consistency: :strong

  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Projections.Command

  project(%Events.Command.Added{application: application, configuration: configuration}, _metadata, fn multi ->
    command = %Command{
      application: application,
      component: configuration.component,
      name: configuration.name,
      schema: configuration.schema,
      handler: configuration.handler
    }

    Ecto.Multi.insert(multi, :command, command)
  end)

  project(%Events.Command.Updated{application: application, configuration: configuration}, _metadata, fn multi ->
    query =
      from(c in Command,
        where: c.application == ^application and c.name == ^configuration.name
      )

    command = %Command{
      application: application,
      component: configuration.component,
      name: configuration.name,
      schema: configuration.schema,
      handler: configuration.handler
    }

    Ecto.Multi.update(multi, :command, query, set: command)
  end)

  project(%Events.Command.Removed{application: application, configuration: configuration}, _metadata, fn multi ->
    query =
      from(c in Command,
        where: c.application == ^application and c.name == ^configuration.name
      )

    Ecto.Multi.delete_all(multi, :command, query)
  end)
end
