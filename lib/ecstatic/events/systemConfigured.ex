defmodule Ecstatic.Events.SystemConfigured do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name
  ]
end
