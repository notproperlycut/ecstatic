defmodule Ecstatic.Repo.Migrations.AddFamilyTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_families) do
      add :application_id, references(:ecstatic_applications)
      add :name, :text
      add :criteria, :text
      add :belongs_to_system, :text

      timestamps()
    end

    create index(:ecstatic_families, [:application_id])
    create index(:ecstatic_families, [:application_id, :name])
    create index(:ecstatic_families, [:application_id, :belongs_to_system])
  end
end
