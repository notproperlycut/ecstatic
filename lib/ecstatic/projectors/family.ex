defmodule Ecstatic.Projectors.Family do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded,
    repo: Ecstatic.Repo,
    name: "Projectors.Family",
    consistency: :strong

  alias Ecstatic.Events
  alias Ecstatic.Projections.Family

  project(%Events.FamilyConfigured{} = event, _metadata, fn multi ->
    family = %Family{
      application_id: event.application_id,
      name: event.name,
      criteria: event.criteria
    }

    Ecto.Multi.insert(multi, :family, family,
      on_conflict: [set: [criteria: event.criteria]],
      conflict_target: [:application_id, :name]
    )
  end)

  project(%Events.FamilyRemoved{} = event, _metadata, fn multi ->
    query =
      from(c in Family, where: c.application_id == ^event.application_id and c.name == ^event.name)

    Ecto.Multi.delete_all(multi, :family, query)
  end)
end
