defmodule Ecstatic.Projections.Component do
  use Ecto.Schema

  schema "components" do
    field(:application_id, :string)
    field(:name, :string)
    field(:schema, :map)
  end
end
