defmodule Ecstatic.Commands.EventInvocation.Succeed do
  use TypedStruct
  alias Ecstatic.Types.EventInvocation

  typedstruct do
    field :entity_component_id, Types.EntityComponentId.t(), enforce: true
    field :invocation, EventInvocation.t(), enforce: true
    field :entity_component_state, any(), enforce: true
  end
end
