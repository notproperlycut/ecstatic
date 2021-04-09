defmodule Ecstatic.Repo.Migrations.AddComponentTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_component_types) do
      add :application_id, :binary_id
      add :name, :text
      add :schema, :map
      add :belongs_to_system, :text

      timestamps()
    end

    create index(:ecstatic_component_types, [:application_id])
    create index(:ecstatic_component_types, [:application_id, :name])
    create index(:ecstatic_component_types, [:application_id, :belongs_to_system])
  end
end
