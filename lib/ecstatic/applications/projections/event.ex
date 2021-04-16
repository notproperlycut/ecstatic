defmodule Ecstatic.Applications.Projections.Event do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.{
    Application,
    ComponentType,
    Handler,
    System
  }

  schema "ecstatic_events" do
    field(:name, :string)
    field(:schema, :map)
    embeds_one(:handler, Handler)
    belongs_to :application, Application
    belongs_to :system, System
    belongs_to :component_type, ComponentType

    timestamps()
  end
end
