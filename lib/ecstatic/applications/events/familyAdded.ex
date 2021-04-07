defmodule Ecstatic.Applications.Events.FamilyAdded do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name,
    :criteria,
    :belongs_to_system
  ]
end
