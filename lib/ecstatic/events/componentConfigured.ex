defmodule Ecstatic.Events.ComponentConfigured do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name
  ]
end
