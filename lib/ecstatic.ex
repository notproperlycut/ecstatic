defmodule Ecstatic do
  alias Ecstatic.Commanded.Commands
  alias Ecstatic.Commanded.Types
  alias Ecstatic.Commanded.Projections

  defdelegate application(name), to: Ecstatic.Application, as: :get
  defdelegate applications(), to: Ecstatic.Application, as: :list

  defdelegate system(application, name), to: Ecstatic.System, as: :get
  defdelegate systems(application), to: Ecstatic.System, as: :list

  defdelegate family(application, name), to: Ecstatic.Family, as: :get
  defdelegate families(application), to: Ecstatic.Family, as: :list

  defdelegate component(application, name), to: Ecstatic.Component, as: :get
  defdelegate components(application), to: Ecstatic.Component, as: :list

  defdelegate command(application, name), to: Ecstatic.Command, as: :get
  defdelegate commands(application), to: Ecstatic.Command, as: :list

  defdelegate event(application, name), to: Ecstatic.Event, as: :get
  defdelegate events(application), to: Ecstatic.Event, as: :list

  defdelegate subscriber(application, name), to: Ecstatic.Subscriber, as: :get
  defdelegate subscribers(application), to: Ecstatic.Subscriber, as: :list

  defdelegate configure(application, configuration), to: Ecstatic.Application
  defdelegate remove(application), to: Ecstatic.Application

  def execute_command(application, entity, command, payload) do
    with %Ecstatic.Commanded.Projections.Command{component: component, schema: schema} <-
           command(application, command),
         schema <- ExJsonSchema.Schema.resolve(Jason.decode!(schema["json_schema"])),
         :ok <- ExJsonSchema.Validator.validate(schema, payload),
         {:ok, entity_component} <-
           Ecstatic.Types.Name.entity_component(application, component, entity),
         invocation <- %Types.CommandInvocation{
           application: application,
           command: command,
           entity_component: entity_component,
           payload: payload
         } do
      Ecstatic.Commanded.Application.dispatch(%Commands.CommandInvocation.Request{
        entity_component: entity_component,
        invocation: invocation
      })
    end
  end

  def entity_component(application, name) do
    Ecstatic.Commanded.Repo.get_by(Projections.EntityComponent,
      application: application,
      name: name
    )
  end

  def entity_components(application) do
    Ecstatic.Commanded.Repo.all(Projections.EntityComponent, application: application)
  end
end
