defmodule Ecstatic.Commanded.Commands.CommandInvocation.Fail do
  use TypedStruct
  alias Ecstatic.Commanded.Types.CommandInvocation

  typedstruct do
    field :entity_component, String.t(), enforce: true
    field :invocation, CommandInvocation.t(), enforce: true
    field :error, String.t(), enforce: true
  end
end
