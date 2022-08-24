defmodule Ecstatic.Repo.Migrations.CreateFamilyProjection do
  use Ecto.Migration

  def change do
    create table(:families) do
      add :application_id, :string
      add :name, :string
      add :criteria, :map
    end

    create unique_index(:families, [:application_id, :name])

  end
end
