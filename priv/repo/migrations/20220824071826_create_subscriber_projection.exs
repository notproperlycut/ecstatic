defmodule Ecstatic.Repo.Migrations.CreateSubscriberProjection do
  use Ecto.Migration

  def change do
    create table(:subscribers) do
      add :application_id, :string
      add :component_name, :string
      add :name, :string
      add :trigger, :map
      add :handler, :map
    end

    create unique_index(:subscribers, [:application_id, :name])

  end
end
