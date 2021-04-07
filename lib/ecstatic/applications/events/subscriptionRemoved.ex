defmodule Ecstatic.Applications.Events.SubscriptionRemoved do
  @derive Jason.Encoder
  defstruct [:application_id, :name]
end
