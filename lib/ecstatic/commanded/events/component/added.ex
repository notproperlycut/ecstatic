defmodule Ecstatic.Commanded.Events.Component.Added do
  @derive Jason.Encoder
  @derive {Nestru.Decoder, %{configuration: Ecstatic.Component.Configuration}}

  use TypedStruct

  typedstruct do
    field :application, String.t(), enforce: true
    field :configuration, Ecstatic.Component.Configuration.t(), enforce: true
  end
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Commanded.Events.Component.Added do
  def decode(%Ecstatic.Commanded.Events.Component.Added{} = event) do
    Nestru.decode_from_map!(event, Ecstatic.Commanded.Events.Component.Added)
  end
end
