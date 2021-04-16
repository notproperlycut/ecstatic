defmodule Ecstatic.Applications.Events.ComponentTypeAdded do
  @derive Jason.Encoder

  defstruct [
    :id,
    :name,
    :schema,
    :application_id,
    :system_id
  ]
end
