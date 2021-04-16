defmodule Ecstatic.Repo.Migrations.AddFamilyTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_families) do
      add :name, :text
      add :criteria, :text
      add :application_id, :binary_id
      add :system_id, :binary_id

      timestamps()
    end

    create index(:ecstatic_families, [:application_id])
    create index(:ecstatic_families, [:system_id])
  end
end
