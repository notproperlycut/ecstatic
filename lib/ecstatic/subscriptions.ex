defmodule Ecstatic.Subscriptions do
  @moduledoc """
  The boundary for the Applications system.
  """

  import Ecto.Query

  alias Ecstatic.Applications.Projections.{
    Subscription,
    ComponentType
  }
  alias Ecstatic.Repo

  @doc """
  Get a subscription by name
  """
  def get(application_id, name) do
    case Repo.get_by(Subscription, application_id: application_id, name: name) do
      nil -> {:error, :subscriptions_not_found}
      subscription -> {:ok, subscription}
    end
  end

  @doc """
  List subscriptions
  """
  def list_by_application(application_id) do
    subscriptions = from(s in Subscription, where: s.application_id == ^application_id) |> Repo.all()
    {:ok, subscriptions}
  end

  @doc """
  List subscriptions
  """
  def list_by_component_type(application_id, component_type_name) do
    subscriptions = from(s in Subscription, where: s.application_id == ^application_id and s.belongs_to_component_type == ^component_type_name) |> Repo.all()
    {:ok, subscriptions}
  end

  @doc """
  List subscriptions
  """
  def list_by_system(application_id, system_name) do
    subscriptions = from(c in Subscription, join: ct in ComponentType, on: ct.name == c.belongs_to_component_type, where: ct.application_id == ^application_id and ct.belongs_to_system == ^system_name) |> Repo.all()
    {:ok, subscriptions}
  end
end
