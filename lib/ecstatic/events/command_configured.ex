defmodule Ecstatic.Events.CommandConfigured do
  use Domo, skip_defaults: true
  @derive Jason.Encoder
  alias Ecstatic.Types

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

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Events.CommandConfigured do
  def decode(%Ecstatic.Events.CommandConfigured{schema: schema, handler: handler} = event) do
    %Ecstatic.Events.CommandConfigured{
      event
      | schema: struct(Ecstatic.Types.Schema, schema),
        handler:
          struct(Ecstatic.Types.Handler, handler) |> Commanded.Serialization.JsonDecoder.decode()
    }
  end
end
