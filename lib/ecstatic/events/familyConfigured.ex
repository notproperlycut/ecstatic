defmodule Ecstatic.Events.FamilyConfigured do
  @derive Jason.Encoder

  defstruct [
    :id,
    :parent_system_id,
    :name,
  ]
end
