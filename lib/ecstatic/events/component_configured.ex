defmodule Ecstatic.Events.ComponentConfigured do
  use Domo, skip_defaults: true
  @derive Jason.Encoder
  alias Ecstatic.Types

  use TypedStruct

  typedstruct do
    field :application_id, Types.ApplicationId.t(), enforce: true
    field :name, String.t(), enforce: true
    field :schema, Types.Schema.t(), enforce: true
  end

  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Events.ComponentConfigured do
  def decode(%Ecstatic.Events.ComponentConfigured{schema: schema} = event) do
    %Ecstatic.Events.ComponentConfigured{event | schema: struct(Ecstatic.Types.Schema, schema)}
  end
end
