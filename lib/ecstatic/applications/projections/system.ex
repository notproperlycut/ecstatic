defmodule Ecstatic.Applications.Projections.System do
  use Ecstatic.Applications.Projections.Schema

  schema "ecstatic_systems" do
    field(:name, :string)
    field(:application_id, :binary_id)

    timestamps()
  end
end
