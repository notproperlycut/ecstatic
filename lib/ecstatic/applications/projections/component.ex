defmodule Ecstatic.Applications.Projections.ComponentType do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.{
    Application,
    Command,
    Event,
    Subscription,
    System
  }

  schema "ecstatic_component_types" do
    field(:name, :string)
    field(:schema, :map)
    belongs_to :application, Application
    belongs_to :system, System
    has_many :commands, Command
    has_many :events, Event
    has_many :subscriptions, Subscription

    timestamps()
  end
end
