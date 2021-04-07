defmodule Ecstatic.Applications.Events.EventAdded do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name,
    :schema,
    :handler,
    :belongs_to_component_type
  ]
end
