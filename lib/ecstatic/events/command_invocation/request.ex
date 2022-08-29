defmodule Ecstatic.Events.CommandInvocation.Requested do
  use TypedStruct
  @derive Jason.Encoder
  alias Ecstatic.Types.CommandInvocation

  typedstruct do
    field :invocation, CommandInvocation.t(), enforce: true
  end
end
