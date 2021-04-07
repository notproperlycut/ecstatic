defmodule Ecstatic.Applications.Events.ApplicationCreated do
  @derive {Inspect, except: [:api_secret]}
  @derive Jason.Encoder

  defstruct [:id, :api_secret]
end
