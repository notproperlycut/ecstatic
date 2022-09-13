defmodule Ecstatic.Commanded.Events.Subscriber.Added do
  @derive Jason.Encoder
  @derive {Nestru.Decoder, %{configuration: Ecstatic.Subscriber.Configuration}}

  use TypedStruct

  typedstruct do
    field :application, String.t(), enforce: true
    field :configuration, Ecstatic.Subscriber.Configuration.t(), enforce: true
  end
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Commanded.Events.Subscriber.Added do
  def decode(%Ecstatic.Commanded.Events.Subscriber.Added{} = event) do
    Nestru.decode_from_map!(event, Ecstatic.Commanded.Events.Subscriber.Added)
  end
end
