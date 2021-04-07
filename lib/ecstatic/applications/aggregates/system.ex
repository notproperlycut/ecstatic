defmodule Ecstatic.Applications.Aggregates.System do
  alias Ecstatic.Applications.Aggregates.Application
  alias Ecstatic.Applications.Aggregates.Validators

  alias Ecstatic.Applications.Commands.{
    AddSystem,
    RemoveSystem
  }

  alias Ecstatic.Applications.Events.{
    SystemAdded,
    SystemRemoved
  }

  def add_system(%{id: application_id}, %AddSystem{name: name}) do
    %SystemAdded{application_id: application_id, name: name}
  end

  def remove_system(%{id: application_id, systems: systems}, %RemoveSystem{name: name}) do
    system = Enum.find(systems, fn s -> s.name == name end)

    if system do
      %SystemRemoved{application_id: application_id, name: name}
    else
      {:error, :system_not_present}
    end
  end

  def apply(application, %SystemAdded{} = system) do
    %Application{application | systems: [system | application.systems]}
  end

  def apply(application, %SystemRemoved{} = system) do
    systems = Enum.reject(application.systems, fn s -> s.name == system.name end)
    %Application{application | systems: systems}
  end

  def validate(%{systems: systems}) do
    [Validators.Names.validate_all_unique(systems), Enum.map(systems, &validate(&1))]
    |> Validators.collate_errors()
  end

  def validate(system) do
    Validators.Names.validate_format(system, :system)
  end
end
