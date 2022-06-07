defmodule Ecstatic.Events.FamilyConfigured do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name,
    :criteria
  ]
end
