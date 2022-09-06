defmodule Ecstatic.Commanded.Events.EventInvocation.Failed do
  use TypedStruct
  @derive Jason.Encoder
  alias Ecstatic.Commanded.Types.EventInvocation

  typedstruct do
    field :invocation, EventInvocation.t(), enforce: true
    field :error, String.t(), enforce: true
  end
end
