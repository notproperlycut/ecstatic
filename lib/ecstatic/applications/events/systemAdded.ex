defmodule Ecstatic.Applications.Events.SystemAdded do
  @derive Jason.Encoder
  defstruct [
    :id,
    :name,
    :application_id
  ]
end
