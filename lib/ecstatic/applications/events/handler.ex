defmodule Ecstatic.Applications.Events.Handler do
  @derive Jason.Encoder

  defstruct [
    :url
  ]

  use ExConstructor
end

