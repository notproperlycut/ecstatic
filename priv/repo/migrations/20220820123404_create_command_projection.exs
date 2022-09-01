defmodule Ecstatic.Repo.Migrations.CreateCommandProjection do
  use Ecto.Migration

  def change do
    create table(:commands) do
      add :application, :string
      add :component, :string
      add :name, :string
      add :schema, :map
      add :handler, :map
    end

    create unique_index(:commands, [:application, :name])
  end
end
