defmodule Ecstatic.Repo.Migrations.AddSystemsTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_systems) do
      add :name, :text
      add :application_id, :binary_id

      timestamps()
    end

    create index(:ecstatic_systems, [:application_id])
  end
end
