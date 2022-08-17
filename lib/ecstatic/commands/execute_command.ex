defmodule Ecstatic.Commands.ExecuteCommand do
  use TypedStruct
  alias Ecstatic.Types

  typedstruct do
    field :entity_component_id, Types.EntityComponentId.t(), enforce: true
    field :payload, Types.Payload.t(), enforce: true
  end
end
