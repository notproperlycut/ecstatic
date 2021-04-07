defmodule Ecstatic.Repo.Migrations.CreateApplicationsTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_applications) do
      add :api_secret, :string

      timestamps()
    end
  end
end
