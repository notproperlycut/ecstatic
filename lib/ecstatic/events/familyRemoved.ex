defmodule Ecstatic.Events.FamilyRemoved do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name,
  ]
end
