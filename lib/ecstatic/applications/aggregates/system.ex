defmodule Ecstatic.Applications.Aggregates.System do
  alias Ecstatic.Applications.Aggregates.{
    Application,
    ComponentType,
    Family
  }

  alias Ecstatic.Applications.Aggregates.Validators

  alias Ecstatic.Applications.Events.{
    SystemAdded,
    SystemRemoved
  }

  def add(application, add_system) do
    system = %SystemAdded{
      id: UUID.uuid4(),
      name: add_system.name,
      application_id: application.id
    }

    [
      system,
      ComponentType.add(application, system, add_system.component_types),
      Family.add(application, system, add_system.families)
    ]
    |> List.flatten()
  end

  def remove(application, remove_system) do
    system = Enum.find(application.systems, fn s -> s.name == remove_system.name end)

    if system do
      [
        %SystemRemoved{id: system.id},
        ComponentType.remove(application, system),
        Family.remove(application, system)
      ]
      |> List.flatten()
    else
      {:error, :system_not_present}
    end
  end

  def apply(application, %SystemAdded{} = event) do
    update_in(application.systems, fn systems ->
      [event | systems]
    end)
    |> ComponentType.apply(event)
    |> Family.apply(event)
  end

  def apply(application, %SystemRemoved{} = event) do
    update_in(application.systems, fn systems ->
      Enum.reject(systems, fn s -> s.id == event.id end)
    end)
    |> ComponentType.apply(event)
    |> Family.apply(event)
  end

  def apply(%Application{} = application, event) do
    application
    |> ComponentType.apply(event)
    |> Family.apply(event)
  end

  def validate(application) do
    [
      Validators.Names.validate_all_unique(application.systems),
      Enum.map(application.systems, &validate_system(&1)),
      ComponentType.validate(application),
      Family.validate(application)
    ]
    |> Validators.collate_errors()
  end

  def validate_system(system) do
    Validators.Names.validate_format(system, :system)
  end
end
