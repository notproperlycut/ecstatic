defmodule Ecstatic.ComponentTypes do
  @moduledoc """
  The boundary for the Applications system.
  """

  import Ecto.Query

  alias Ecstatic.Applications.Projections.ComponentType
  alias Ecstatic.Repo

  @doc """
  Get a component type by name
  """
  def get(application_id, name) do
    case Repo.get_by(ComponentType, application_id: application_id, name: name) do
      nil -> {:error, :component_type_not_found}
      component_type -> {:ok, component_type}
    end
  end

  @doc """
  List component types
  """
  def list_by_application(application_id) do
    component_types =
      from(s in ComponentType, where: s.application_id == ^application_id) |> Repo.all()

    {:ok, component_types}
  end

  @doc """
  List component types
  """
  def list_by_system(application_id, system_name) do
    component_types =
      from(s in ComponentType, where: s.application_id == ^application_id and s.belongs_to_system == ^system_name) |> Repo.all()

    {:ok, component_types}
  end
end
