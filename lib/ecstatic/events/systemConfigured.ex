defmodule Ecstatic.Events.SystemConfigured do
  @derive Jason.Encoder

  defstruct [
    :id,
    :parent_application_id,
    :name
  ]
end
