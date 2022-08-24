defmodule Ecstatic.Projections.Event do
  use Ecto.Schema

  schema "events" do
    field(:application_id, :string)
    field(:component_name, :string)
    field(:name, :string)
    field(:schema, :map)
    field(:handler, :map)
  end
end
