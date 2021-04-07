defmodule Ecstatic.Repo.Migrations.AddSystemsTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_systems) do
      add :application_id, references(:ecstatic_applications)
      add :name, :text

      timestamps()
    end

    create index(:ecstatic_systems, [:application_id])
    create index(:ecstatic_systems, [:application_id, :name])
  end
end