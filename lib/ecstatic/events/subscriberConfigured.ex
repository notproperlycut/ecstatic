defmodule Ecstatic.Events.SubscriberConfigured do
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name,
    :trigger,
    :handler
  ]
end
