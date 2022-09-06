defmodule Ecstatic.Commanded.Projectors.Command do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded.Application,
    repo: Ecstatic.Commanded.Repo,
    name: "Projectors.Command",
    consistency: :strong

  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Projections.Command

  project(%Events.CommandConfigured{} = event, _metadata, fn multi ->
    command = %Command{
      application: event.application,
      component: event.component,
      name: event.name,
      schema: event.schema,
      handler: event.handler
    }

    Ecto.Multi.insert(multi, :command, command,
      on_conflict: [set: [handler: event.handler]],
      conflict_target: [:application, :name]
    )
  end)

  project(%Events.CommandRemoved{} = event, _metadata, fn multi ->
    query =
      from(c in Command,
        where: c.application == ^event.application and c.name == ^event.name
      )

    Ecto.Multi.delete_all(multi, :command, query)
  end)
end
