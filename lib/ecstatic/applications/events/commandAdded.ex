defmodule Ecstatic.Applications.Events.CommandAdded do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name,
    :belongs_to_component_type,
    :schema,
    :handler
  ]
end
