defmodule Ecstatic.Projections.EntityComponent do
  use Ecto.Schema

  schema "entity_components" do
    field(:application, :string)
    field(:name, :string)
    field(:value, Ecstatic.Projections.EctoTypeAny)
  end
end
