defmodule Ecstatic.Projections.Command do
  use Ecto.Schema

  schema "commands" do
    field(:application_id, :string)
    field(:component_name, :string)
    field(:name, :string)
    field(:schema, :map)
    field(:handler, :map)
  end
end
