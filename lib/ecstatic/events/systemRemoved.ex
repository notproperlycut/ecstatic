defmodule Ecstatic.Events.SystemRemoved do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name
  ]
end
