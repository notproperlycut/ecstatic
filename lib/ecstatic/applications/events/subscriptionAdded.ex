defmodule Ecstatic.Applications.Events.SubscriptionAdded do
  @derive Jason.Encoder
  defstruct [
    :id,
    :name,
    :payload,
    :handler,
    :trigger,
    :application_id,
    :system_id,
    :component_type_id
  ]
end
