defmodule Ecstatic.Applications.Projections.Family do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.{
    Application,
    System
  }

  schema "ecstatic_families" do
    field(:name, :string)
    field(:criteria, :string)
    belongs_to :application, Application
    belongs_to :system, System

    timestamps()
  end
end
