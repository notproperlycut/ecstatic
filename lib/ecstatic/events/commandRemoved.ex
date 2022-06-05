defmodule Ecstatic.Events.CommandRemoved do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name
  ]
end
