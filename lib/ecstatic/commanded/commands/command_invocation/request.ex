defmodule Ecstatic.Commanded.Commands.CommandInvocation.Request do
  use TypedStruct
  alias Ecstatic.Commanded.Types.CommandInvocation

  # TODO: list of what?
  typedstruct do
    field :entity_component, String.t(), enforce: true
    field :invocation, CommandInvocation.t(), enforce: true
  end
end
