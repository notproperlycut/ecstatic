defmodule Ecstatic.Workflows.CommandInvocation do
  use Commanded.Event.Handler,
    application: Ecstatic.Commanded,
    name: "Workflows.CommandInvocation"

  def handle(%Ecstatic.Events.CommandInvocation.Requested{invocation: invocation}, _metadata) do
    invocation = %Ecstatic.Types.CommandInvocation{
      application_id: invocation.application_id,
      command_name: invocation.command_name,
      entity_component_id: invocation.entity_component_id,
      payload: invocation.payload
    }

    with entity_component <- Ecstatic.entity_component(invocation.application_id, "#{Ecstatic.Types.EntityComponentId.new!(invocation.entity_component_id)}"),
         command <- Ecstatic.command(invocation.application_id, invocation.command_name),
         {:ok, events} <- Ecstatic.Workflows.MfaDispatch.dispatch(command.handler["mfa"], entity_component, invocation.payload),
         {:ok, events} <- Ecstatic.Workflows.VerifyEvents.verify(command, events) do
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
