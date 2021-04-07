defmodule Ecstatic.Applications.Events.ComponentTypeAdded do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name,
    :schema,
    :belongs_to_system
  ]
end
