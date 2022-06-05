defmodule Ecstatic.Events.SubscriberRemoved do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name,
  ]
end
