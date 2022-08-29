defmodule Ecstatic.Repo.Migrations.CreateEntityComponentProjection do
  use Ecto.Migration

  def change do
    create table(:entity_components) do
      add :application_id, :string
      add :entity_component_id, :string
      add :value, :map
    end

    create unique_index(:entity_components, [:application_id, :entity_component_id])
  end
end
