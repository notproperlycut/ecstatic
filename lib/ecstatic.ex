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
    with %Ecstatic.Projections.Command{component_name: component_name, schema: schema} <-
           command(application_id, command),
         schema <- ExJsonSchema.Schema.resolve(Jason.decode!(schema["json_schema"])),
         :ok <- ExJsonSchema.Validator.validate(schema, payload),
         {:ok, entity_component_id} <-
           Types.EntityComponentId.new(%{
             application_id: application_id,
             entity_id: entity_id,
             component_name: component_name
           }),
         invocation <- %Types.CommandInvocation{
           application_id: application_id,
           command_name: command,
           entity_component_id: entity_component_id,
           payload: payload
         } do
      Ecstatic.Commanded.dispatch(%Commands.CommandInvocation.Request{entity_component_id: entity_component_id, invocation: invocation})
    end
  end

  def succeed_command(%Ecstatic.Types.CommandInvocation{} = invocation, events) do
    Ecstatic.Commanded.dispatch(%Commands.CommandInvocation.Succeed{
      entity_component_id: Ecstatic.Types.EntityComponentId.new!(invocation.entity_component_id),
      invocation: invocation,
      events: events
    })
  end

  def fail_command(%Ecstatic.Types.CommandInvocation{} = invocation, error) do
    Ecstatic.Commanded.dispatch(%Commands.CommandInvocation.Fail{
      entity_component_id: Ecstatic.Types.EntityComponentId.new!(invocation.entity_component_id),
      invocation: invocation,
      error: error
    })
  end


  def succeed_event(%Ecstatic.Types.EventInvocation{} = invocation, entity_component_state) do
    Ecstatic.Commanded.dispatch(%Commands.EventInvocation.Succeed{
      entity_component_id: Ecstatic.Types.EntityComponentId.new!(invocation.entity_component_id),
      invocation: invocation,
      entity_component_state: entity_component_state
    }, consistency: :strong)
  end

  def fail_event(%Ecstatic.Types.EventInvocation{} = invocation, error) do
    Ecstatic.Commanded.dispatch(%Commands.EventInvocation.Fail{
      entity_component_id: Ecstatic.Types.EntityComponentId.new!(invocation.entity_component_id),
      invocation: invocation,
      error: error
    })
  end


  def application(id) do
    Ecstatic.Repo.get_by(Projections.Application, id: id)
  end


  def systems(application_id) do
    Ecstatic.Repo.all(Projections.System, application_id: application_id)
  end

  def families(application_id) do
    Ecstatic.Repo.all(Projections.Family, application_id: application_id)
  end

  def components(application_id) do
    Ecstatic.Repo.all(Projections.Component, application_id: application_id)
  end

  def commands(application_id) do
    Ecstatic.Repo.all(Projections.Command, application_id: application_id)
  end

  def events(application_id) do
    Ecstatic.Repo.all(Projections.Event, application_id: application_id)
  end

  def subscribers(application_id) do
    Ecstatic.Repo.all(Projections.Subscriber, application_id: application_id)
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


  def entity_component(application_id, id) do
    Ecstatic.Repo.get_by(Projections.EntityComponent, application_id: application_id, entity_component_id: id)
  end

  def entity_components(application_id) do
    Ecstatic.Repo.all(Projections.EntityComponent, application_id: application_id)
  end
end
