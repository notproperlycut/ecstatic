defmodule Ecstatic.Repo.Migrations.CreateSystemProjection do
  use Ecto.Migration

  def change do
    create table(:systems) do
      add :application_id, :string
      add :name, :string
    end

    create unique_index(:systems, [:application_id, :name])
  end
end
