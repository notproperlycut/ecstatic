defmodule Ecstatic.Engines.Events.EngineCreated do
  @derive Jason.Encoder
  defstruct [:engine_id, :api_secret]
end
