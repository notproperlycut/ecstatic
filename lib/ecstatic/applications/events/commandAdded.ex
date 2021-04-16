defmodule Ecstatic.Applications.Events.CommandAdded do
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
