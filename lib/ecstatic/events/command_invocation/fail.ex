defmodule Ecstatic.Events.CommandInvocation.Failed do
  use TypedStruct
  @derive Jason.Encoder
  alias Ecstatic.Types.CommandInvocation

  typedstruct do
    field :invocation, CommandInvocation.t(), enforce: true
    field :error, String.t(), enforce: true
  end
end
