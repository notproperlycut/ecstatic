defmodule Ecstatic.Commanded.Projections.Component do
  use Ecto.Schema

  schema "components" do
    field(:application, :string)
    field(:system, :string)
    field(:name, :string)
    field(:schema, :map)
  end
end
