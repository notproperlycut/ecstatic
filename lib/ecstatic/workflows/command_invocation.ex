defmodule Ecstatic.Workflows.CommandInvocation do
  use Commanded.Event.Handler,
    application: Ecstatic.Commanded,
    name: "Workflows.CommandInvocation"

  def handle(%Ecstatic.Events.CommandInvocation.Requested{invocation: invocation}, _metadata) do
    invocation = %Ecstatic.Types.CommandInvocation{
      application: invocation.application,
      command: invocation.command,
      entity_component: invocation.entity_component,
      payload: invocation.payload
    }

    with entity_component <- Ecstatic.entity_component(invocation.application, invocation.entity_component),
         command <- Ecstatic.command(invocation.application, invocation.command),
         {:ok, events} <-
           Ecstatic.Workflows.MfaDispatch.dispatch(
             command.handler["mfa"],
             entity_component,
             invocation.payload
           ),
         {:ok, events} <- Ecstatic.Workflows.ResolveAndVerifyEvents.resolve(invocation, events) do
      Ecstatic.succeed_command(invocation, events)
    else
      {:error, error} ->
        Ecstatic.fail_command(invocation, error)

      error ->
        Ecstatic.fail_command(invocation, error)
    end

    :ok
  end
end
