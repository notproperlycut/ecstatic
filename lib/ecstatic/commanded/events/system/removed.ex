defmodule Ecstatic.Commanded.Events.System.Removed do
  @derive Jason.Encoder
  @derive {Nestru.Decoder, %{configuration: Ecstatic.System.Configuration}}

  use TypedStruct

  typedstruct do
    field :application, String.t(), enforce: true
    field :configuration, Ecstatic.System.Configuration.t(), enforce: true
  end
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Commanded.Events.System.Removed do
  def decode(%Ecstatic.Commanded.Events.System.Removed{} = event) do
    Nestru.decode_from_map!(event, Ecstatic.Commanded.Events.System.Removed)
  end
end
