defmodule Ecstatic.Commanded.Events.EventConfigured do
  use Domo, skip_defaults: true
  @derive Jason.Encoder
  alias Ecstatic.Commanded.Types

  use TypedStruct

  typedstruct do
    field :application, String.t(), enforce: true
    field :component, String.t(), enforce: true
    field :name, String.t(), enforce: true
    field :schema, Types.Schema.t(), enforce: true
    field :handler, Types.Handler.t(), enforce: true
  end

  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Commanded.Events.EventConfigured do
  def decode(%Ecstatic.Commanded.Events.EventConfigured{schema: schema, handler: handler} = event) do
    %Ecstatic.Commanded.Events.EventConfigured{
      event
      | schema: struct(Ecstatic.Commanded.Types.Schema, schema),
        handler:
          struct(Ecstatic.Commanded.Types.Handler, handler) |> Commanded.Serialization.JsonDecoder.decode()
    }
  end
end