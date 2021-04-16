defmodule Ecstatic.Applications.Projections.System do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.{
    Application,
    Command,
    ComponentType,
    Event,
    Family,
    Subscription
  }

  schema "ecstatic_systems" do
    field(:name, :string)
    belongs_to :application, Application
    has_many :commands, Command
    has_many :component_types, ComponentType
    has_many :events, Event
    has_many :families, Family
    has_many :subscriptions, Subscription

    timestamps()
  end
end
