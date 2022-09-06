defmodule Ecstatic.Commanded.Projections.EntityComponent do
  use Ecto.Schema

  schema "entity_components" do
    field(:application, :string)
    field(:name, :string)
    field(:value, Ecstatic.Commanded.Projections.EctoTypeAny)
  end
end
