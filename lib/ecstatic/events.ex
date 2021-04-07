defmodule Ecstatic.Events do
  @moduledoc """
  The boundary for the Applications system.
  """

  import Ecto.Query

  alias Ecstatic.Applications.Projections.{
    Event,
    ComponentType
  }
  alias Ecstatic.Repo

  @doc """
  Get a event by name
  """
  def get(application_id, name) do
    case Repo.get_by(Event, application_id: application_id, name: name) do
      nil -> {:error, :event_not_found}
      event -> {:ok, event}
    end
  end

  @doc """
  List events
  """
  def list_by_application(application_id) do
    events = from(s in Event, where: s.application_id == ^application_id) |> Repo.all()
    {:ok, events}
  end

  @doc """
  List events
  """
  def list_by_component_type(application_id, component_type_name) do
    events = from(s in Event, where: s.application_id == ^application_id and s.belongs_to_component_type == ^component_type_name) |> Repo.all()
    {:ok, events}
  end

  @doc """
  List events
  """
  def list_by_system(application_id, system_name) do
    events = from(c in Event, join: ct in ComponentType, on: ct.name == c.belongs_to_component_type, where: ct.application_id == ^application_id and ct.belongs_to_system == ^system_name) |> Repo.all()
    {:ok, events}
  end
end
