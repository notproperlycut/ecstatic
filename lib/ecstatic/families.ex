defmodule Ecstatic.Families do
  @moduledoc """
  The boundary for the Applications system.
  """

  import Ecto.Query

  alias Ecstatic.Applications.Projections.Family
  alias Ecstatic.Repo

  @doc """
  Get a family by name
  """
  def get(application_id, name) do
    case Repo.get_by(Family, application_id: application_id, name: name) do
      nil -> {:error, :family_not_found}
      family -> {:ok, family}
    end
  end

  @doc """
  List families
  """
  def list_by_application(application_id) do
    families = from(s in Family, where: s.application_id == ^application_id) |> Repo.all()
    {:ok, families}
  end

  @doc """
  List families
  """
  def list_by_system(application_id, system_name) do
    families =
      from(s in Family,
        where: s.application_id == ^application_id and s.belongs_to_system == ^system_name
      )
      |> Repo.all()

    {:ok, families}
  end
end
