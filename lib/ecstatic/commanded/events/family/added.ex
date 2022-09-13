defmodule Ecstatic.Commanded.Events.Family.Added do
  @derive Jason.Encoder
  @derive {Nestru.Decoder, %{configuration: Ecstatic.Family.Configuration}}

  use TypedStruct

  typedstruct do
    field :application, String.t(), enforce: true
    field :configuration, Ecstatic.Family.Configuration.t(), enforce: true
  end
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Commanded.Events.Family.Added do
  def decode(%Ecstatic.Commanded.Events.Family.Added{} = event) do
    Nestru.decode_from_map!(event, Ecstatic.Commanded.Events.Family.Added)
  end
end
