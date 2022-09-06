defmodule Ecstatic.Commanded.Events.EventInvocation.Succeeded do
  use TypedStruct
  @derive Jason.Encoder
  alias Ecstatic.Commanded.Types.EventInvocation

  typedstruct do
    field :invocation, EventInvocation.t(), enforce: true
    field :entity_component_state, any(), enforce: true
  end
end
