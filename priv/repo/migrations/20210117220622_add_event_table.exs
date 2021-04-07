defmodule Ecstatic.Repo.Migrations.AddEventTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_events) do
      add :application_id, references(:ecstatic_applications)
      add :name, :text
      add :schema, :map
      add :handler, :map
      add :belongs_to_component_type, :text

      timestamps()
    end

    create index(:ecstatic_events, [:application_id])
    create index(:ecstatic_events, [:application_id, :name])
    create index(:ecstatic_events, [:application_id, :belongs_to_component_type])
  end
end
