defmodule Ecstatic.Projections.Event do
  use Ecto.Schema

  schema "events" do
    field(:application, :string)
    field(:component, :string)
    field(:name, :string)
    field(:schema, :map)
    field(:handler, :map)
  end
end
