defmodule Ecstatic.Engines.Events.EngineCreated do
  @derive {Inspect, except: [:api_secret]}
  @derive Jason.Encoder
  defstruct [:engine_id, :api_secret]
end
