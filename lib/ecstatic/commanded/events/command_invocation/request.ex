defmodule Ecstatic.Commanded.Events.CommandInvocation.Requested do
  use TypedStruct
  @derive Jason.Encoder
  alias Ecstatic.Commanded.Types.CommandInvocation

  typedstruct do
    field :invocation, CommandInvocation.t(), enforce: true
  end
end
