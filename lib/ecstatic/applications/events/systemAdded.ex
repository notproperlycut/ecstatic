defmodule Ecstatic.Applications.Events.SystemAdded do
  @derive Jason.Encoder
  defstruct [
    :application_id,
    :name
  ]
end
