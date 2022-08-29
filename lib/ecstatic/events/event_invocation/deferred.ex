defmodule Ecstatic.Events.EventInvocation.Deferred do
  use TypedStruct
  @derive Jason.Encoder
  alias Ecstatic.Types.EventInvocation

  typedstruct do
    field :invocation, EventInvocation.t(), enforce: true
  end
end
