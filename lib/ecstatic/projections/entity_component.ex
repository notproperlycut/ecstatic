defmodule Ecstatic.Projections.EntityComponent do
  use Ecto.Schema

  schema "entity_components" do
    field(:application_id, :string)
    field(:entity_component_id, :string)
    field(:value, Ecstatic.Projections.EctoTypeAny)
  end
end
