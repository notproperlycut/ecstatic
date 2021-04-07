defmodule Ecstatic.Repo.Migrations.AddCommandsTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_commands) do
      add :application_id, references(:ecstatic_applications)
      add :name, :text
      add :schema, :map
      add :belongs_to_component_type, :text
      add :handler, :map

      timestamps()
    end

    create index(:ecstatic_commands, [:application_id])
    create index(:ecstatic_commands, [:application_id, :name])
    create index(:ecstatic_commands, [:application_id, :belongs_to_component_type])
  end
end
