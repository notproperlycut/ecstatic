defmodule Ecstatic.Events.EventRemoved do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name
  ]
end
