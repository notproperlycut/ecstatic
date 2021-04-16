defmodule Ecstatic.Applications.Projectors.Family do
  use Commanded.Projections.Ecto,
    application: Ecstatic.App,
    name: "Applications.Projectors.Family",
    consistency: :strong

  alias Ecstatic.Applications.Events.{
    ApplicationDestroyed,
    FamilyAdded,
    FamilyRemoved
  }

  alias Ecstatic.Applications.Projections.Family

  project(%FamilyAdded{} = family, fn multi ->
    Ecto.Multi.insert(multi, :create, %Family{
      application_id: family.application_id,
      system_id: family.system_id,
      id: family.id,
      name: family.name,
      criteria: family.criteria
    })
  end)

  project(%FamilyRemoved{} = family, fn multi ->
    family_query =
      from(c in Family,
        where: c.id == ^family.id
      )

    Ecto.Multi.delete_all(multi, :destroy, family_query)
  end)

  project(%ApplicationDestroyed{} = application, fn multi ->
    family_query = from(e in Family, where: e.application_id == ^application.id)
    Ecto.Multi.delete_all(multi, :destroy, family_query)
  end)
end
