defmodule Ecstatic.Applications.Projections.System do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.Application

  schema "ecstatic_systems" do
    field(:name, :string)
    belongs_to :application, Application

    timestamps()
  end
end
