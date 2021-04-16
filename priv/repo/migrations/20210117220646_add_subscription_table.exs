defmodule Ecstatic.Repo.Migrations.AddSubscriptionTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_subscriptions) do
      add :name, :text
      add :trigger, :text
      add :payload, :text
      add :handler, :map
      add :application_id, :binary_id
      add :system_id, :binary_id
      add :component_type_id, :binary_id

      timestamps()
    end

    create index(:ecstatic_subscriptions, [:application_id])
    create index(:ecstatic_subscriptions, [:system_id])
    create index(:ecstatic_subscriptions, [:component_type_id])
  end
end
