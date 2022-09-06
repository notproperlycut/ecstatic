defmodule Ecstatic.Commanded.Workflows.CommandInvocation do
  use Commanded.Event.Handler,
    application: Ecstatic.Commanded.Application,
    name: "Workflows.CommandInvocation"

  def handle(%Ecstatic.Commanded.Events.CommandInvocation.Requested{invocation: invocation}, _metadata) do
    invocation = %Ecstatic.Commanded.Types.CommandInvocation{
      application: invocation.application,
      command: invocation.command,
      entity_component: invocation.entity_component,
      payload: invocation.payload
    }

    with entity_component <- Ecstatic.entity_component(invocation.application, invocation.entity_component),
         command <- Ecstatic.command(invocation.application, invocation.command),
         {:ok, events} <-
           Ecstatic.Commanded.Workflows.MfaDispatch.dispatch(
             command.handler["mfa"],
             entity_component,
             invocation.payload
           ),
         {:ok, events} <- Ecstatic.Commanded.Workflows.ResolveAndVerifyEvents.resolve(invocation, events) do
      Ecstatic.Commanded.succeed_command(invocation, events)
    else
      {:error, error} ->
        Ecstatic.Commanded.fail_command(invocation, error)

      error ->
        Ecstatic.Commanded.fail_command(invocation, error)
    end

    :ok
  end
end
