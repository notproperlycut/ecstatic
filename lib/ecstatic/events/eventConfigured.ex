defmodule Ecstatic.Events.EventConfigured do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name
  ]
end
