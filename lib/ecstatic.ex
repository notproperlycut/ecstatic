defmodule Ecstatic do
  alias Ecstatic.Commands
  alias Ecstatic.Types
  alias Ecstatic.Projections

  def configure_application(%Commands.ConfigureApplication{} = application) do
    Ecstatic.Commanded.dispatch(application, consistency: :strong)
  end

  def remove_application(%Commands.RemoveApplication{} = application) do
    Ecstatic.Commanded.dispatch(application, consistency: :strong)
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

  def application(id) do
    Ecstatic.Repo.get_by(Projections.Application, id: id)
  end

  def system(application_id, name) do
    Ecstatic.Repo.get_by(Projections.System, application_id: application_id, name: name)
  end

  def family(application_id, name) do
    Ecstatic.Repo.get_by(Projections.Family, application_id: application_id, name: name)
  end

  def component(application_id, name) do
    Ecstatic.Repo.get_by(Projections.Component, application_id: application_id, name: name)
  end

  def command(application_id, name) do
    Ecstatic.Repo.get_by(Projections.Command, application_id: application_id, name: name)
  end

  def event(application_id, name) do
    Ecstatic.Repo.get_by(Projections.Event, application_id: application_id, name: name)
  end

  def subscriber(application_id, name) do
    Ecstatic.Repo.get_by(Projections.Subscriber, application_id: application_id, name: name)
  end
end
