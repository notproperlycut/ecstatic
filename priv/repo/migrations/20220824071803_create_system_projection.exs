defmodule Ecstatic.Repo.Migrations.CreateSystemProjection do
  use Ecto.Migration

  def change do
    create table(:systems) do
      add :application, :string
      add :name, :string
    end

    create unique_index(:systems, [:application, :name])
  end
end
