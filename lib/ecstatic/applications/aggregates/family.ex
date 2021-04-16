defmodule Ecstatic.Applications.Aggregates.Family do
  alias Ecstatic.Applications.Aggregates.Validators

  alias Ecstatic.Applications.Aggregates.Application

  alias Ecstatic.Applications.Events.{
    FamilyAdded,
    FamilyRemoved
  }

  def add(application, system, add_families) do
    add_families
    |> Enum.map(&add_family(application, system, &1))
    |> List.flatten()
  end

  defp add_family(application, system, add_family) do
    %FamilyAdded{
      id: UUID.uuid4(),
      name: add_family.name,
      criteria: add_family.criteria,
      application_id: application.id,
      system_id: system.id
    }
  end

  def remove(application, system) do
    application.families
    |> Enum.filter(&(&1.system_id == system.id))
    |> Enum.map(&remove_family(&1))
    |> List.flatten()
  end

  defp remove_family(family) do
    %FamilyRemoved{id: family.id}
  end

  def apply(application, %FamilyAdded{} = event) do
    %Application{application | families: [event | application.families]}
  end

  def apply(application, %FamilyRemoved{} = event) do
    families = Enum.reject(application.families, fn s -> s.id == event.id end)
    %Application{application | families: families}
  end

  def apply(%Application{} = application, _event) do
    application
  end

  def validate(application) do
    [
      Validators.Names.validate_all_unique(application.families),
      Enum.map(application.families, &validate_family(&1, application))
    ]
    |> Validators.collate_errors()
  end

  def validate_family(family, application) do
    [
      Validators.Names.validate_format(family, :family),
      Validators.Names.validate_share_system(family, :system_id, application, :systems),
      validate_criteria(family, application)
    ]
  end

  defp validate_criteria(family, application) do
    String.split(family.criteria, " ")
    |> Enum.map(
      &Validators.Entities.validate_exists_by_name(&1, application, [:component_types, :families])
    )
    |> Validators.collate_errors()
    |> Validators.prepend_message("Criteria for family #{family.name}, ")
  end
end
