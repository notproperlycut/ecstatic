defmodule Ecstatic.Repo.Migrations.CreateEventProjection do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :application, :string
      add :component, :string
      add :name, :string
      add :schema, :map
      add :handler, :map
    end

    create unique_index(:events, [:application, :name])

  end
end
