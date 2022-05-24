defmodule Ecstatic.Events.EventConfigured do
  @derive Jason.Encoder

  defstruct [
    :id,
    :parent_component_id,
    :name
  ]
end
