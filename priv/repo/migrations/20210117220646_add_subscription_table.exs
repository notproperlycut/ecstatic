defmodule Ecstatic.Repo.Migrations.AddSubscriptionTable do
  use Ecto.Migration

  def change do
    create table(:ecstatic_subscriptions) do
      add :application_id, :binary_id
      add :name, :text
      add :trigger, :text
      add :payload, :text
      add :handler, :map
      add :belongs_to_component_type, :text

      timestamps()
    end

    create index(:ecstatic_subscriptions, [:application_id])
    create index(:ecstatic_subscriptions, [:application_id, :name])
    create index(:ecstatic_subscriptions, [:application_id, :belongs_to_component_type])
  end
end
