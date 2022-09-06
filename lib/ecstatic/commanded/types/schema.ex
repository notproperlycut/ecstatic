defmodule Ecstatic.Commanded.Types.Schema do
  @derive Jason.Encoder
  use Domo, skip_defaults: true

  use TypedStruct

  typedstruct do
    field :json_schema, String.t(), enforce: true
  end

  precond(
    t: fn s ->
      try do
        ExJsonSchema.Schema.resolve(Jason.decode!(s.json_schema))
        :ok
      rescue
        [ExJsonSchema.Schema.InvalidSchemaError, Jason.DecodeError] ->
          {:error, "invalid json schema '#{String.slice(s.json_schema, 0..20)}'"}
      end
    end
  )

  def empty() do
    __MODULE__.new!(%{json_schema: Jason.encode!(%{"type" => "null"})})
  end
end
