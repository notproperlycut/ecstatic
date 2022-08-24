defmodule Ecstatic.Projectors.Command do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded,
    repo: Ecstatic.Repo,
    name: "Projectors.Command",
    consistency: :strong

  alias Ecstatic.Events
  alias Ecstatic.Projections.Command

  project(%Events.CommandConfigured{} = event, _metadata, fn multi ->
    command = %Command{
      application_id: event.application_id,
      component_name: event.component_name,
      name: event.name,
      schema: event.schema,
      handler: event.handler
    }

    Ecto.Multi.insert(multi, :command, command,
      on_conflict: [set: [handler: event.handler]],
      conflict_target: [:application_id, :name]
    )
  end)

  project(%Events.CommandRemoved{} = event, _metadata, fn multi ->
    query =
      from(c in Command,
        where: c.application_id == ^event.application_id and c.name == ^event.name
      )

    Ecto.Multi.delete_all(multi, :command, query)
  end)
end
