defmodule Ecstatic.Applications.Aggregates.Command do
  alias Ecstatic.Applications.Aggregates.Application

  alias Ecstatic.Applications.Events.{
    CommandAdded,
    CommandRemoved,
    Handler
  }

  alias Ecstatic.Applications.Aggregates.Validators

  def add(application, system, component_type, add_commands) do
    add_commands
    |> Enum.map(&add_command(application, system, component_type, &1))
    |> List.flatten()
  end

  defp add_command(application, system, component_type, add_command) do
    %CommandAdded{
      id: UUID.uuid4(),
      name: add_command.name,
      schema: add_command.schema,
      handler: Handler.new(add_command.handler),
      application_id: application.id,
      system_id: system.id,
      component_type_id: component_type.id
    }
  end

  def remove(application, component_type) do
    application.commands
    |> Enum.filter(&(&1.component_type_id == component_type.id))
    |> Enum.map(&remove_command(&1))
    |> List.flatten()
  end

  defp remove_command(command) do
    %CommandRemoved{id: command.id}
  end

  def apply(application, %CommandAdded{} = event) do
    %Application{application | commands: [event | application.commands]}
  end

  def apply(application, %CommandRemoved{} = event) do
    commands = Enum.reject(application.commands, fn s -> s.id == event.id end)
    %Application{application | commands: commands}
  end

  def apply(%Application{} = application, _event) do
    application
  end

  def validate(application) do
    [
      Validators.Names.validate_all_unique(application.commands),
      Enum.map(application.commands, &validate_command(&1, application))
    ]
    |> Validators.collate_errors()
  end

  def validate_command(command, application) do
    [
      Validators.Names.validate_format(command, :command),
      Validators.Names.validate_share_system(
        command,
        :component_type_id,
        application,
        :component_types
      ),
      Validators.JsonSchema.validate(command),
      Validators.Handler.validate(command)
    ]
  end
end
