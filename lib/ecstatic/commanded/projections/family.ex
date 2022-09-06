defmodule Ecstatic.Commanded.Projections.Family do
  use Ecto.Schema

  schema "families" do
    field(:application, :string)
    field(:name, :string)
    field(:criteria, :map)
  end
end
