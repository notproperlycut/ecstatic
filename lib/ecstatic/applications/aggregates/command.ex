defmodule Ecstatic.Applications.Aggregates.Command do
  alias Ecstatic.Applications.Aggregates.Application

  alias Ecstatic.Applications.Commands.{
    AddSystem,
    RemoveSystem
  }

  alias Ecstatic.Applications.Events.{
    CommandAdded,
    CommandRemoved,
    Handler
  }

  alias Ecstatic.Applications.Aggregates.Validators

  def add_system(%{id: application_id}, %AddSystem{} = add_system) do
    add_system.component_types
    |> Enum.flat_map(fn ct ->
      Enum.map(ct.commands, fn c ->
        %CommandAdded{
          application_id: application_id,
          name: c.name,
          belongs_to_component_type: ct.name,
          schema: c.schema,
          handler: Handler.new(c.handler)
        }
      end)
    end)
  end

  def remove_system(
        %{id: application_id, component_types: component_types, commands: commands},
        %RemoveSystem{name: name}
      ) do
    component_types
    |> Enum.filter(fn ct -> ct.belongs_to_system == name end)
    |> Enum.flat_map(fn ct ->
      Enum.filter(commands, fn c -> c.belongs_to_component_type == ct.name end)
    end)
    |> Enum.map(fn c ->
      %CommandRemoved{application_id: application_id, name: c.name}
    end)
  end

  def apply(application, %CommandAdded{} = command) do
    %Application{application | commands: [command | application.commands]}
  end

  def apply(application, %CommandRemoved{} = command) do
    commands = Enum.reject(application.commands, fn s -> s.name == command.name end)
    %Application{application | commands: commands}
  end

  def validate(%{commands: commands} = application) do
    [Validators.Names.validate_all_unique(commands), Enum.map(commands, &validate(&1, application))]
    |> Validators.collate_errors()
  end

  def validate(command, application) do
    [
      Validators.Names.validate_format(command, :command),
      Validators.Names.validate_share_system(command, :belongs_to_component_type),
      Validators.Entities.validate_relation(command, :belongs_to_component_type, application, :component_types),
      Validators.JsonSchema.validate(command),
      Validators.Handler.validate(command)
    ]
  end
end
