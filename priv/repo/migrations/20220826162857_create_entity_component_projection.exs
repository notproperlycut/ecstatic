defmodule Ecstatic.Repo.Migrations.CreateEntityComponentProjection do
  use Ecto.Migration

  def change do
    create table(:entity_components) do
      add :application, :string
      add :name, :string
      add :value, :map
    end

    create unique_index(:entity_components, [:application, :name])
  end
end
