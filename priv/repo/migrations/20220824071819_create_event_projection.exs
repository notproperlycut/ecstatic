defmodule Ecstatic.Repo.Migrations.CreateEventProjection do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :application_id, :string
      add :component_name, :string
      add :name, :string
      add :schema, :map
      add :handler, :map
    end

    create unique_index(:events, [:application_id, :name])

  end
end
