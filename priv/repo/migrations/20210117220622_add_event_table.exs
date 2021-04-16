defmodule Ecstatic.Repo.Migrations.AddEventTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_events) do
      add :name, :text
      add :schema, :map
      add :handler, :map
      add :application_id, :binary_id
      add :system_id, :binary_id
      add :component_type_id, :binary_id

      timestamps()
    end

    create index(:ecstatic_events, [:application_id])
    create index(:ecstatic_events, [:system_id])
    create index(:ecstatic_events, [:component_type_id])
  end
end
