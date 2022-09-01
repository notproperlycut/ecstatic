defmodule Ecstatic.Types.CommandInvocation do
  use TypedStruct
  @derive Jason.Encoder
  alias Ecstatic.Types

  typedstruct do
    field :application, Types.ApplicationId.t(), enforce: true
    field :command, String.t(), enforce: true
    field :entity_component, Types.EntityComponentId.t(), enforce: true
    field :payload, Types.Payload.t(), enforce: true
  end
end
