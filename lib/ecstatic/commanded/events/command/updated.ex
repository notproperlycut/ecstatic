defmodule Ecstatic.Commanded.Events.Command.Updated do
  @derive Jason.Encoder
  @derive {Nestru.Decoder, %{configuration: Ecstatic.Command.Configuration}}

  use TypedStruct

  typedstruct do
    field :application, String.t(), enforce: true
    field :configuration, Ecstatic.Command.Configuration.t(), enforce: true
  end
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Commanded.Events.Command.Updated do
  def decode(%Ecstatic.Commanded.Events.Command.Updated{} = event) do
    Nestru.decode_from_map!(event, Ecstatic.Commanded.Events.Command.Updated)
  end
end
