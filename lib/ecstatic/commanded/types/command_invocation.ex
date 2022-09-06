defmodule Ecstatic.Commanded.Types.CommandInvocation do
  use TypedStruct
  @derive Jason.Encoder
  alias Ecstatic.Commanded.Types

  typedstruct do
    field :application, String.t(), enforce: true
    field :command, String.t(), enforce: true
    field :entity_component, String.t(), enforce: true
    field :payload, Types.Payload.t(), enforce: true
  end
end
