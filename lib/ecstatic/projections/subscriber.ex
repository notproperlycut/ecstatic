defmodule Ecstatic.Projections.Subscriber do
  use Ecto.Schema

  schema "subscribers" do
    field(:application_id, :string)
    field(:component_name, :string)
    field(:name, :string)
    field(:trigger, :map)
    field(:handler, :map)
  end
end
