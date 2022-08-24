defmodule Ecstatic.Projectors.Component do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded,
    repo: Ecstatic.Repo,
    name: "Projectors.Component",
    consistency: :strong

  alias Ecstatic.Events
  alias Ecstatic.Projections.Component

  project(%Events.ComponentConfigured{} = event, _metadata, fn multi ->
    component = %Component{
      application_id: event.application_id,
      name: event.name
    }

    Ecto.Multi.insert(multi, :component, component, on_conflict: :nothing)
  end)

  project(%Events.ComponentRemoved{} = event, _metadata, fn multi ->
    query =
      from(c in Component,
        where: c.application_id == ^event.application_id and c.name == ^event.name
      )

    Ecto.Multi.delete_all(multi, :component, query)
  end)
end
