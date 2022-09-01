defmodule Ecstatic.Commands.CommandInvocation.Succeed do
  use TypedStruct
  alias Ecstatic.Types.CommandInvocation

  # TODO: list of what?
  typedstruct do
    field :entity_component, String.t(), enforce: true
    field :invocation, CommandInvocation.t(), enforce: true
    field :events, list(), enforce: true
  end
end
