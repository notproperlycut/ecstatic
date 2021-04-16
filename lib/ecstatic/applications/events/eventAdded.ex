defmodule Ecstatic.Applications.Events.EventAdded do
  @derive Jason.Encoder

  defstruct [
    :id,
    :name,
    :schema,
    :handler,
    :application_id,
    :system_id,
    :component_type_id
  ]
end
