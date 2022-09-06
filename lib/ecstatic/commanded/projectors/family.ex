defmodule Ecstatic.Commanded.Projectors.Family do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded.Application,
    repo: Ecstatic.Commanded.Repo,
    name: "Projectors.Family",
    consistency: :strong

  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Projections.Family

  project(%Events.FamilyConfigured{} = event, _metadata, fn multi ->
    family = %Family{
      application: event.application,
      name: event.name,
      criteria: event.criteria
    }

    Ecto.Multi.insert(multi, :family, family,
      on_conflict: [set: [criteria: event.criteria]],
      conflict_target: [:application, :name]
    )
  end)

  project(%Events.FamilyRemoved{} = event, _metadata, fn multi ->
    query =
      from(c in Family, where: c.application == ^event.application and c.name == ^event.name)

    Ecto.Multi.delete_all(multi, :family, query)
  end)
end