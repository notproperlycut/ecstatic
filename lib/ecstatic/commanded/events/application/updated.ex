defmodule Ecstatic.Commanded.Events.Application.Updated do
  @derive Jason.Encoder
  @derive {Nestru.Decoder, %{configuration: Ecstatic.Application.Configuration}}

  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
    field :configuration, Ecstatic.Application.Configuration.t(), enforce: true
  end
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Commanded.Events.Application.Updated do
  def decode(%Ecstatic.Commanded.Events.Application.Updated{} = event) do
    Nestru.decode_from_map!(event, Ecstatic.Commanded.Events.Application.Updated)
  end
end