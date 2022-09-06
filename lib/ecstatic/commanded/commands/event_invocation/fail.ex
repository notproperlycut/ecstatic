defmodule Ecstatic.Commanded.Commands.EventInvocation.Fail do
  use TypedStruct
  alias Ecstatic.Commanded.Types.EventInvocation

  typedstruct do
    field :entity_component, String.t(), enforce: true
    field :invocation, EventInvocation.t(), enforce: true
    field :error, String.t(), enforce: true
  end
end
