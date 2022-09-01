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

  def execute_command(application, entity, command, payload) do
    with %Ecstatic.Projections.Command{component: component, schema: schema} <-
           command(application, command),
         schema <- ExJsonSchema.Schema.resolve(Jason.decode!(schema["json_schema"])),
         :ok <- ExJsonSchema.Validator.validate(schema, payload),
         {:ok, entity_component} <-
           Types.EntityComponentId.new(%{
             application: application,
             entity: entity,
             component: component
           }),
         invocation <- %Types.CommandInvocation{
           application: application,
           command: command,
           entity_component: entity_component,
           payload: payload
         } do
      Ecstatic.Commanded.dispatch(%Commands.CommandInvocation.Request{
        entity_component: entity_component,
        invocation: invocation
      })
    end
  end

  def succeed_command(%Ecstatic.Types.CommandInvocation{} = invocation, events) do
    Ecstatic.Commanded.dispatch(%Commands.CommandInvocation.Succeed{
      entity_component: Ecstatic.Types.EntityComponentId.new!(invocation.entity_component),
      invocation: invocation,
      events: events
    })
  end

  def fail_command(%Ecstatic.Types.CommandInvocation{} = invocation, error) do
    Ecstatic.Commanded.dispatch(%Commands.CommandInvocation.Fail{
      entity_component: Ecstatic.Types.EntityComponentId.new!(invocation.entity_component),
      invocation: invocation,
      error: error
    })
  end

  def succeed_event(%Ecstatic.Types.EventInvocation{} = invocation, entity_component_state) do
    Ecstatic.Commanded.dispatch(
      %Commands.EventInvocation.Succeed{
        entity_component:
          Ecstatic.Types.EntityComponentId.new!(invocation.entity_component),
        invocation: invocation,
        entity_component_state: entity_component_state
      },
      consistency: :strong
    )
  end

  def fail_event(%Ecstatic.Types.EventInvocation{} = invocation, error) do
    Ecstatic.Commanded.dispatch(%Commands.EventInvocation.Fail{
      entity_component: Ecstatic.Types.EntityComponentId.new!(invocation.entity_component),
      invocation: invocation,
      error: error
    })
  end

  def application(name) do
    Ecstatic.Repo.get_by(Projections.Application, name: name)
  end

  def systems(application) do
    Ecstatic.Repo.all(Projections.System, application: application)
  end

  def families(application) do
    Ecstatic.Repo.all(Projections.Family, application: application)
  end

  def components(application) do
    Ecstatic.Repo.all(Projections.Component, application: application)
  end

  def commands(application) do
    Ecstatic.Repo.all(Projections.Command, application: application)
  end

  def events(application) do
    Ecstatic.Repo.all(Projections.Event, application: application)
  end

  def subscribers(application) do
    Ecstatic.Repo.all(Projections.Subscriber, application: application)
  end

  def system(application, name) do
    Ecstatic.Repo.get_by(Projections.System, application: application, name: name)
  end

  def family(application, name) do
    Ecstatic.Repo.get_by(Projections.Family, application: application, name: name)
  end

  def component(application, name) do
    Ecstatic.Repo.get_by(Projections.Component, application: application, name: name)
  end

  def command(application, name) do
    Ecstatic.Repo.get_by(Projections.Command, application: application, name: name)
  end

  def event(application, name) do
    Ecstatic.Repo.get_by(Projections.Event, application: application, name: name)
  end

  def subscriber(application, name) do
    Ecstatic.Repo.get_by(Projections.Subscriber, application: application, name: name)
  end

  def entity_component(application, name) do
    Ecstatic.Repo.get_by(Projections.EntityComponent,
      application: application,
      name: name
    )
  end

  def entity_components(application) do
    Ecstatic.Repo.all(Projections.EntityComponent, application: application)
  end
end
