defmodule Ecstatic.Applications.Projections.Family do
  use Ecstatic.Applications.Projections.Schema

  schema "ecstatic_families" do
    field(:name, :string)
    field(:application_id, :binary_id)
    field(:belongs_to_system, :string)
    field(:criteria, :string)

    timestamps()
  end
end
