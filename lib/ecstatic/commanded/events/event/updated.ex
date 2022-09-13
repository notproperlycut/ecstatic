defmodule Ecstatic.Commanded.Events.Event.Updated do
  @derive Jason.Encoder
  @derive {Nestru.Decoder, %{configuration: Ecstatic.Event.Configuration}}

  use TypedStruct

  typedstruct do
    field :application, String.t(), enforce: true
    field :configuration, Ecstatic.Event.Configuration.t(), enforce: true
  end
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Commanded.Events.Event.Updated do
  def decode(%Ecstatic.Commanded.Events.Event.Updated{} = event) do
    Nestru.decode_from_map!(event, Ecstatic.Commanded.Events.Event.Updated)
  end
end
