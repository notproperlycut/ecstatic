defmodule Ecstatic.Applications.Events.FamilyAdded do
  @derive Jason.Encoder

  defstruct [
    :id,
    :name,
    :criteria,
    :application_id,
    :system_id
  ]
end
