defmodule Ecstatic.Commands.EventInvocation.Fail do
  use TypedStruct
  alias Ecstatic.Types.EventInvocation

  typedstruct do
    field :entity_component_id, Types.EntityComponentId.t(), enforce: true
    field :invocation, EventInvocation.t(), enforce: true
    field :error, String.t(), enforce: true
  end
end
