defmodule Ecstatic.Events.CommandInvocation.Succeeded do
  use TypedStruct
  @derive Jason.Encoder
  alias Ecstatic.Types.CommandInvocation

  # TODO: list of what?
  typedstruct do
    field :invocation, CommandInvocation.t(), enforce: true
    field :events, List.t(), enforce: true
  end
end
