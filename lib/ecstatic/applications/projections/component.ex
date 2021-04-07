defmodule Ecstatic.Applications.Projections.ComponentType do
  use Ecstatic.Applications.Projections.Schema

  schema "ecstatic_component_types" do
    field(:name, :string)
    field(:application_id, :binary_id)
    field(:belongs_to_system, :string)
    field(:schema, :map)

    timestamps()
  end
end
