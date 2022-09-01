defmodule Ecstatic.Commands.CommandInvocation.Fail do
  use TypedStruct
  alias Ecstatic.Types.CommandInvocation

  typedstruct do
    field :entity_component, Types.EntityComponentId.t(), enforce: true
    field :invocation, CommandInvocation.t(), enforce: true
    field :error, String.t(), enforce: true
  end
end
