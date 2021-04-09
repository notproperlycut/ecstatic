defmodule Ecstatic.Applications.Projections.ComponentType do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.Application

  schema "ecstatic_component_types" do
    field(:name, :string)
    field(:belongs_to_system, :string)
    field(:schema, :map)
    belongs_to :application, Application

    timestamps()
  end
end
