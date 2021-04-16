defmodule Ecstatic.Repo.Migrations.AddCommandsTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_commands) do
      add :name, :text
      add :schema, :map
      add :handler, :map
      add :application_id, :binary_id
      add :system_id, :binary_id
      add :component_type_id, :binary_id

      timestamps()
    end

    create index(:ecstatic_commands, [:application_id])
    create index(:ecstatic_commands, [:system_id])
    create index(:ecstatic_commands, [:component_type_id])
  end
end
