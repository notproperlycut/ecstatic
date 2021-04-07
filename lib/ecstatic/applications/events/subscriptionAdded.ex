defmodule Ecstatic.Applications.Events.SubscriptionAdded do
  @derive Jason.Encoder
  defstruct [
    :application_id,
    :name,
    :payload,
    :handler,
    :trigger,
    :belongs_to_component_type
  ]
end
