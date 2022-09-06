defmodule Ecstatic.Commanded do
  alias Ecstatic.Commanded.Commands

  def succeed_command(%Ecstatic.Commanded.Types.CommandInvocation{} = invocation, events) do
    Ecstatic.Commanded.Application.dispatch(%Commands.CommandInvocation.Succeed{
      entity_component: invocation.entity_component,
      invocation: invocation,
      events: events
    })
  end

  def fail_command(%Ecstatic.Commanded.Types.CommandInvocation{} = invocation, error) do
    Ecstatic.Commanded.Application.dispatch(%Commands.CommandInvocation.Fail{
      entity_component: invocation.entity_component,
      invocation: invocation,
      error: error
    })
  end

  def succeed_event(%Ecstatic.Commanded.Types.EventInvocation{} = invocation, entity_component_state) do
    Ecstatic.Commanded.Application.dispatch(
      %Commands.EventInvocation.Succeed{
        entity_component: invocation.entity_component,
        invocation: invocation,
        entity_component_state: entity_component_state
      },
      consistency: :strong
    )
  end

  def fail_event(%Ecstatic.Commanded.Types.EventInvocation{} = invocation, error) do
    Ecstatic.Commanded.Application.dispatch(%Commands.EventInvocation.Fail{
      entity_component: invocation.entity_component,
      invocation: invocation,
      error: error
    })
  end
end
