defmodule Ecstatic.Aggregates.EntityComponent do
  use TypedStruct

  alias Ecstatic.Aggregates.EntityComponent
  alias Ecstatic.Commands
  alias Ecstatic.Events
  alias Ecstatic.Types

  typedstruct do
    field :state, any(), default: nil
  end

  #
  def execute(_, %Commands.CommandInvocation.Request{invocation: invocation}) do
    %Ecstatic.Events.CommandInvocation.Requested{
      invocation: invocation
    }
  end

  def execute(_, %Commands.CommandInvocation.Succeed{invocation: invocation, events: events}) do
    succeed = %Ecstatic.Events.CommandInvocation.Succeeded{
      invocation: invocation,
      events: events
    }

    # TODO: defer and order these
    event_requests = events |> Enum.map(fn event ->
      # TODO: resolve the event name
      event_invocation = %Types.EventInvocation{
        application_id: invocation.application_id,
        event_name: event.name,
        entity_component_id: invocation.entity_component_id,
        payload: event.value
      }
      %Ecstatic.Events.EventInvocation.Requested{
        invocation: event_invocation
      }
    end)

    [succeed | event_requests]
  end

  def execute(_, %Commands.CommandInvocation.Fail{invocation: invocation, error: error}) do
    %Ecstatic.Events.CommandInvocation.Failed{
      invocation: invocation,
      error: error
    }
  end

  def execute(_, %Commands.EventInvocation.Succeed{invocation: invocation, entity_component_state: entity_component_state}) do
    %Ecstatic.Events.EventInvocation.Succeeded{
      invocation: invocation,
      entity_component_state: entity_component_state
    }
  end

  def execute(_, %Commands.EventInvocation.Fail{invocation: invocation, error: error}) do
    %Ecstatic.Events.EventInvocation.Failed{
      invocation: invocation,
      error: error
    }
  end
  #

  def apply(_, %Events.CommandInvocation.Requested{}) do
    %EntityComponent{state: :requested}
  end

  def apply(_, %Events.CommandInvocation.Succeeded{}) do
    %EntityComponent{state: :succeeded}
  end

  def apply(_, %Events.CommandInvocation.Failed{}) do
    %EntityComponent{state: :failed}
  end

  def apply(_, %Events.EventInvocation.Requested{}) do
    %EntityComponent{state: :requested}
  end

  def apply(_, %Events.EventInvocation.Succeeded{}) do
    %EntityComponent{state: :succeeded}
  end

  def apply(_, %Events.EventInvocation.Failed{}) do
    %EntityComponent{state: :failed}
  end
end
