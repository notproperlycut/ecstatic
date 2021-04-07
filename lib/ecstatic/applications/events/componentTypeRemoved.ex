defmodule Ecstatic.Applications.Events.ComponentTypeRemoved do
  @derive Jason.Encoder
  defstruct [:application_id, :name]
end
