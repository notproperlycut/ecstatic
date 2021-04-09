defmodule Ecstatic.Applications.Projections.Family do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.Application

  schema "ecstatic_families" do
    field(:name, :string)
    field(:belongs_to_system, :string)
    field(:criteria, :string)
    belongs_to :application, Application

    timestamps()
  end
end
