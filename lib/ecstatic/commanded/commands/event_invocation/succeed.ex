defmodule Ecstatic.Commanded.Commands.EventInvocation.Succeed do
  use TypedStruct
  alias Ecstatic.Commanded.Types.EventInvocation

  typedstruct do
    field :entity_component, String.t(), enforce: true
    field :invocation, EventInvocation.t(), enforce: true
    field :entity_component_state, any(), enforce: true
  end
end
