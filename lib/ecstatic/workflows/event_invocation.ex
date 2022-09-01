defmodule Ecstatic.Workflows.EventInvocation do
  use Commanded.Event.Handler,
    application: Ecstatic.Commanded,
    name: "Workflows.EventInvocation"

  def handle(%Ecstatic.Events.EventInvocation.Requested{invocation: invocation}, _metadata) do
    invocation = %Ecstatic.Types.EventInvocation{
      application: invocation.application,
      event: invocation.event,
      entity_component: invocation.entity_component,
      payload: invocation.payload
    }

    with entity_component <-
           Ecstatic.entity_component(
             invocation.application,
             "#{Ecstatic.Types.EntityComponentId.new!(invocation.entity_component)}"
           ),
         event <- Ecstatic.event(invocation.application, invocation.event),
         {:ok, entity_component_state} <-
           Ecstatic.Workflows.MfaDispatch.dispatch(
             event.handler["mfa"],
             entity_component,
             invocation.payload
           ),
         {:ok, entity_component_state} <-
           Ecstatic.Workflows.VerifyEntityComponentState.verify(event, entity_component_state) do
      Ecstatic.succeed_event(invocation, entity_component_state)
    else
      {:error, error} ->
        Ecstatic.fail_event(invocation, error)

      error ->
        Ecstatic.fail_event(invocation, error)
    end

    :ok
  end
end
