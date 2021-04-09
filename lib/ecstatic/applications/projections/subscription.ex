defmodule Ecstatic.Applications.Projections.Subscription do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.{
    Application,
    Handler
  }

  schema "ecstatic_subscriptions" do
    field(:name, :string)
    field(:belongs_to_component_type, :string)

    field(:trigger, :string)
    field(:payload, :string)
    embeds_one(:handler, Handler)
    belongs_to :application, Application

    timestamps()
  end
end
