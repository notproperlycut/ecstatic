defmodule Ecstatic.Commanded.Events.CommandInvocation.Succeeded do
  use TypedStruct
  @derive Jason.Encoder
  alias Ecstatic.Commanded.Types.CommandInvocation

  # TODO: list of what?
  typedstruct do
    field :invocation, CommandInvocation.t(), enforce: true
    field :events, List.t(), enforce: true
  end
end
