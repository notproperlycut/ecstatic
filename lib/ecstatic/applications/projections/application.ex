defmodule Ecstatic.Applications.Projections.Application do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.{
    Command,
    ComponentType,
    Event,
    Family,
    Subscription,
    System
  }

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "ecstatic_applications" do
    field(:api_secret, :string)
    has_many :commands, Command
    has_many :component_types, ComponentType
    has_many :events, Event
    has_many :families, Family
    has_many :subscriptions, Subscription
    has_many :systems, System

    timestamps()
  end
end
