defmodule Ecstatic.Types.EventInvocation do
  use TypedStruct
  @derive Jason.Encoder
  alias Ecstatic.Types

  typedstruct do
    field :application_id, Types.ApplicationId.t(), enforce: true
    field :event_name, String.t(), enforce: true
    field :entity_component_id, Types.EntityComponentId.t(), enforce: true
    field :payload, Types.Payload.t(), enforce: true
  end
end
