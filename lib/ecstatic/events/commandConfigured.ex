defmodule Ecstatic.Events.CommandConfigured do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name
  ]
end
