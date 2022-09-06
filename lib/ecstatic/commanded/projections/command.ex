defmodule Ecstatic.Commanded.Projections.Command do
  use Ecto.Schema

  schema "commands" do
    field(:application, :string)
    field(:component, :string)
    field(:name, :string)
    field(:schema, :map)
    field(:handler, :map)
  end
end
