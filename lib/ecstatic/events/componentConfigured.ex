defmodule Ecstatic.Events.ComponentConfigured do
  @derive Jason.Encoder

  defstruct [
    :id,
    :parent_system_id,
    :name,
  ]
end
