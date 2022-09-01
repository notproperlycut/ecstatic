defmodule Ecstatic.Repo.Migrations.CreateApplicationProjection do
  use Ecto.Migration

  def change do
    create table(:applications) do
      add :name, :string
    end

    create index(:applications, [:name])
  end
end
