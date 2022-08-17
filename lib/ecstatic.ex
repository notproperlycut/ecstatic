defmodule Ecstatic do
  alias Ecstatic.Commands
  alias Ecstatic.Types

  def configure_application(%Commands.ConfigureApplication{} = application) do
    Ecstatic.Commanded.dispatch(application)
  end

  def remove_application(%Commands.RemoveApplication{} = application) do
    Ecstatic.Commanded.dispatch(application)
  end

  def execute_command(application_id, entity_id, command, payload) do
    # TODO:
    # locate component (from app_id and command)
    # validate payload
    # send command
    {:ok, entity_component_id} =
      Types.EntityComponentId.new(%{
        application_id: application_id,
        entity_id: entity_id,
        component_name: command
      })

    command = %Commands.ExecuteCommand{
      entity_component_id: entity_component_id,
      payload: payload
    }

    Ecstatic.Commanded.dispatch(command)
  end
end
