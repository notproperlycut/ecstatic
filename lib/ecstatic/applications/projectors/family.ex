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
      name: family.name,
      belongs_to_system: family.belongs_to_system,
      criteria: family.criteria
    })
  end)

  project(%FamilyRemoved{} = family, fn multi ->
    family_query =
      from(c in Family,
        where: c.name == ^family.name and c.application_id == ^family.application_id
      )

    Ecto.Multi.delete_all(multi, :destroy, family_query)
  end)

  project(%ApplicationDestroyed{} = application, fn multi ->
    family_query = from(e in Family, where: e.application_id == ^application.id)
    Ecto.Multi.delete_all(multi, :destroy, family_query)
  end)
end
