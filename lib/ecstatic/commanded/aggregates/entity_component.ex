defmodule Ecstatic.Commanded.Aggregates.EntityComponent do
  use TypedStruct

  alias Ecstatic.Commanded.Aggregates.EntityComponent
  alias Ecstatic.Commanded.Commands
  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Types

  typedstruct do
    field :invocation, Events.CommandInvocation.t() | nil, default: nil
    field :events, list(Events.EventInvocation.t()), default: []
  end

  #
  def execute(%EntityComponent{invocation: nil}, %Commands.CommandInvocation.Request{
        invocation: invocation
      }) do
    %Ecstatic.Commanded.Events.CommandInvocation.Requested{
      invocation: invocation
    }
  end

  def execute(_, %Commands.CommandInvocation.Request{}) do
    {:error, :command_already_executing}
  end

  def execute(_, %Commands.CommandInvocation.Succeed{invocation: invocation, events: events}) do
    succeed = %Ecstatic.Commanded.Events.CommandInvocation.Succeeded{
      invocation: invocation,
      events: events
    }

    deferred =
      Enum.map(events, fn event ->
        %Ecstatic.Commanded.Events.EventInvocation.Deferred{
          invocation: %Types.EventInvocation{
            application: invocation.application,
            event: event.name,
            entity_component: invocation.entity_component,
            payload: event.value
          }
        }
      end)

    requested =
      deferred
      |> Enum.take(1)
      |> Enum.map(fn d ->
        %Ecstatic.Commanded.Events.EventInvocation.Requested{
          invocation: d.invocation
        }
      end)

    deferred ++ [succeed] ++ requested
  end

  def execute(_, %Commands.CommandInvocation.Fail{invocation: invocation, error: error}) do
    %Ecstatic.Commanded.Events.CommandInvocation.Failed{
      invocation: invocation,
      error: error
    }
  end

  def execute(%EntityComponent{events: [_first | remaining]}, %Commands.EventInvocation.Succeed{
        invocation: invocation,
        entity_component_state: entity_component_state
      }) do
    succeed = %Ecstatic.Commanded.Events.EventInvocation.Succeeded{
      invocation: invocation,
      entity_component_state: entity_component_state
    }

    requested =
      remaining
      |> Enum.take(1)
      |> Enum.map(fn d ->
        %Ecstatic.Commanded.Events.EventInvocation.Requested{
          invocation: d.invocation
        }
      end)

    [succeed] ++ requested
  end

  def execute(_, %Commands.EventInvocation.Fail{invocation: invocation, error: error}) do
    %Ecstatic.Commanded.Events.EventInvocation.Failed{
      invocation: invocation,
      error: error
    }
  end

  #

  def apply(aggregate, %Events.CommandInvocation.Requested{} = invocation) do
    %{aggregate | invocation: invocation}
  end

  def apply(%EntityComponent{events: []}, %Events.CommandInvocation.Succeeded{}) do
    %EntityComponent{}
  end

  def apply(aggregate, %Events.CommandInvocation.Succeeded{}) do
    aggregate
  end

  def apply(_, %Events.CommandInvocation.Failed{}) do
    %EntityComponent{}
  end

  def apply(aggregate, %Events.EventInvocation.Deferred{} = event) do
    %{aggregate | events: aggregate.events ++ [event]}
  end

  def apply(aggregate, %Events.EventInvocation.Requested{}) do
    aggregate
  end

  def apply(%EntityComponent{events: [_first]}, %Events.EventInvocation.Succeeded{}) do
    %EntityComponent{}
  end

  def apply(
        %EntityComponent{events: [_first | remaining]} = aggregate,
        %Events.EventInvocation.Succeeded{}
      ) do
    %{aggregate | events: remaining}
  end

  def apply(_, %Events.EventInvocation.Failed{}) do
    %EntityComponent{}
  end
end
