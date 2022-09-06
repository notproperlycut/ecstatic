defmodule Ecstatic.Commanded.Projections.Subscriber do
  use Ecto.Schema

  schema "subscribers" do
    field(:application, :string)
    field(:component, :string)
    field(:name, :string)
    field(:trigger, :map)
    field(:handler, :map)
  end
end
