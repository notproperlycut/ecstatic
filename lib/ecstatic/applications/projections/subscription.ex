defmodule Ecstatic.Applications.Projections.Subscription do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.{
    Application,
    ComponentType,
    Handler,
    System
  }

  schema "ecstatic_subscriptions" do
    field(:name, :string)
    field(:trigger, :string)
    field(:payload, :string)
    embeds_one(:handler, Handler)
    belongs_to :application, Application
    belongs_to :system, System
    belongs_to :component_type, ComponentType

    timestamps()
  end
end
