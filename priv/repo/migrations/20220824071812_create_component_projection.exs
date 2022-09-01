defmodule Ecstatic.Repo.Migrations.CreateComponentProjection do
  use Ecto.Migration

  def change do
    create table(:components) do
      add :application, :string
      add :name, :string
      add :schema, :map
    end

    create unique_index(:components, [:application, :name])
  end
end
