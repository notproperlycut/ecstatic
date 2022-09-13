defmodule Ecstatic.Commanded.Projectors.Family do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded.Application,
    repo: Ecstatic.Commanded.Repo,
    name: "Projectors.Family",
    consistency: :strong

  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Projections.Family

  project(%Events.Family.Added{application: application, configuration: configuration}, _metadata, fn multi ->
    family = %Family{
      application: application,
      system: configuration.system,
      name: configuration.name,
      criteria: configuration.criteria
    }

    Ecto.Multi.insert(multi, :family, family)
  end)

  project(%Events.Family.Updated{application: application, configuration: configuration}, _metadata, fn multi ->
    query =
      from(c in Family, where: c.application == ^application and c.name == ^configuration.name)

    family = %Family{
      application: application,
      system: configuration.system,
      name: configuration.name,
      criteria: configuration.criteria
    }

    Ecto.Multi.update(multi, :family, query, set: family)
  end)

  project(%Events.Family.Removed{application: application, configuration: configuration}, _metadata, fn multi ->
    query =
      from(c in Family, where: c.application == ^application and c.name == ^configuration.name)

    Ecto.Multi.delete_all(multi, :family, query)
  end)
end
