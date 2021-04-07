defmodule Ecstatic.Applications.Projections.Subscription do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.Handler

  schema "ecstatic_subscriptions" do
    field(:application_id, :binary_id)
    field(:name, :string)
    field(:belongs_to_component_type, :string)

    field(:trigger, :string)
    field(:payload, :string)
    embeds_one(:handler, Handler)

    timestamps()
  end
end
