defmodule Ecstatic.Repo.Migrations.CreateFamilyProjection do
  use Ecto.Migration

  def change do
    create table(:families) do
      add :application, :string
      add :system, :string
      add :name, :string
      add :criteria, :map
    end

    create unique_index(:families, [:application, :name])

  end
end
