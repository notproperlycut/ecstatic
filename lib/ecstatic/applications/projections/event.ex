defmodule Ecstatic.Applications.Projections.Event do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.{
    Application,
    Handler
  }

  schema "ecstatic_events" do
    field(:name, :string)
    field(:schema, :map)
    field(:belongs_to_component_type, :string)
    embeds_one(:handler, Handler)
    belongs_to :application, Application

    timestamps()
  end
end
