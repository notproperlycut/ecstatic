defmodule Ecstatic.Applications.Commands.CreateApplication do
  @derive {Inspect, except: [:api_secret]}
  defstruct [:id, :api_secret]

  use ExConstructor
end
