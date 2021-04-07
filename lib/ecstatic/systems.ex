defmodule Ecstatic.Systems do
  @moduledoc """
  The boundary for the Applications system.
  """

  import Ecto.Query

  alias Ecstatic.Applications.Projections.System
  alias Ecstatic.Repo

  @doc """
  Get a system by name
  """
  def get(application_id, name) do
    case Repo.get_by(System, application_id: application_id, name: name) do
      nil -> {:error, :system_not_found}
      system -> {:ok, system}
    end
  end

  @doc """
  List all systems
  """
  def list(application_id) do
    systems = from(s in System, where: s.application_id == ^application_id) |> Repo.all()
    {:ok, systems}
  end
end
