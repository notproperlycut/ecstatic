defmodule Ecstatic.Events.ComponentRemoved do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name
  ]
end
