defmodule Ecstatic.Repo.Migrations.CreateApplicationProjection do
  use Ecto.Migration

  def change do
    create table(:applications, primary_key: false) do
      add :id, :string, primary_key: true
    end
  end
end
