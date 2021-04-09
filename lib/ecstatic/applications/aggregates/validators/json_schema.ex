defmodule Ecstatic.Applications.Aggregates.Validators.JsonSchema do
  def validate(thing, fieldname \\ :schema) do
    schema = Map.get(thing, fieldname)

    if valid_schema?(schema) do
      :ok
    else
      {:error, "#{thing.name} has an invalid json schema"}
    end
  end

  defp valid_schema?(schema) do
    try do
      ExJsonSchema.Schema.resolve(schema)
      true
    rescue
      ExJsonSchema.Schema.InvalidSchemaError -> false
    end
  end
end
