defmodule Ecstatic.Types.Schema do
  @derive Jason.Encoder
  @derive Nestru.Decoder

  use TypedStruct
  use Domo, skip_defaults: true

  typedstruct do
    field :json_schema, map(), enforce: true
  end

  precond(
    t: fn s ->
      try do
        ExJsonSchema.Schema.resolve(s.json_schema)
        :ok
      rescue
        e in ExJsonSchema.Schema.InvalidSchemaError ->
          {:error, "invalid json schema '#{e.message}'"}
      end
    end
  )
end
