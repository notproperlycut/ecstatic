defmodule Ecstatic.Commanded.Events.EventInvocation.Requested do
  use TypedStruct
  @derive Jason.Encoder
  alias Ecstatic.Commanded.Types.EventInvocation

  typedstruct do
    field :invocation, EventInvocation.t(), enforce: true
  end
end
