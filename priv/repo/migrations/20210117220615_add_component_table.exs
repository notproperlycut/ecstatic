defmodule Ecstatic.Repo.Migrations.AddComponentTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_component_types) do
      add :name, :text
      add :schema, :map
      add :application_id, :binary_id
      add :system_id, :binary_id

      timestamps()
    end

    create index(:ecstatic_component_types, [:application_id])
    create index(:ecstatic_component_types, [:system_id])
  end
end
