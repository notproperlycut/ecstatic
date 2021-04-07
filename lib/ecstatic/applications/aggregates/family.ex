defmodule Ecstatic.Applications.Aggregates.Family do
  alias Ecstatic.Applications.Aggregates.Validators

  alias Ecstatic.Applications.Aggregates.Application

  alias Ecstatic.Applications.Commands.{
    AddSystem,
    RemoveSystem
  }

  alias Ecstatic.Applications.Events.{
    FamilyAdded,
    FamilyRemoved
  }

  def add_system(%{id: application_id}, %AddSystem{} = add_system) do
    add_system.families
    |> Enum.map(fn f ->
      %FamilyAdded{
        application_id: application_id,
        belongs_to_system: add_system.name,
        name: f.name,
        criteria: f.criteria
      }
    end)
  end

  def remove_system(%{id: application_id, families: families}, %RemoveSystem{
        name: name
      }) do
    families
    |> Enum.filter(fn f -> f.belongs_to_system == name end)
    |> Enum.map(fn f ->
      %FamilyRemoved{application_id: application_id, name: f.name}
    end)
  end

  def apply(application, %FamilyAdded{} = family) do
    %Application{application | families: [family | application.families]}
  end

  def apply(application, %FamilyRemoved{} = family) do
    families = Enum.reject(application.families, fn s -> s.name == family.name end)
    %Application{application | families: families}
  end

  def validate(%{families: families} = application) do
    [Validators.Names.validate_all_unique(families), Enum.map(families, &validate(&1, application))]
    |> Validators.collate_errors()
  end

  def validate(family, application) do
    [
      Validators.Names.validate_format(family, :family),
      Validators.Names.validate_share_system(family, :belongs_to_system),
      Validators.Entities.validate_relation(family, :belongs_to_system, application, :systems),
      validate_criteria(family, application)
    ]
  end

  defp validate_criteria(family, application) do
    String.split(family.criteria, " ")
    |> Enum.map(&Validators.Entities.validate_exists(&1, application, [:component_types, :families]))
    |> Validators.collate_errors()
    |> Validators.prepend_message("Criteria for family #{family.name}, ")
  end
end
