defmodule Ecstatic.Projections.Family do
  use Ecto.Schema

  schema "families" do
    field(:application_id, :string)
    field(:name, :string)
    field(:criteria, :map)
  end
end
