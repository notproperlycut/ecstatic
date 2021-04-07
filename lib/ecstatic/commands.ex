defmodule Ecstatic.Commands do
  @moduledoc """
  The boundary for the Applications system.
  """

  import Ecto.Query

  alias Ecstatic.Applications.Projections.{
    Command,
    ComponentType
  }
  alias Ecstatic.Repo

  @doc """
  Get a command by name
  """
  def get(application_id, name) do
    case Repo.get_by(Command, application_id: application_id, name: name) do
      nil -> {:error, :command_not_found}
      command -> {:ok, command}
    end
  end

  @doc """
  List commands
  """
  def list_by_application(application_id) do
    commands = from(s in Command, where: s.application_id == ^application_id) |> Repo.all()
    {:ok, commands}
  end

  @doc """
  List commands
  """
  def list_by_component_type(application_id, component_type_name) do
    commands = from(s in Command, where: s.application_id == ^application_id and s.belongs_to_component_type == ^component_type_name) |> Repo.all()
    {:ok, commands}
  end

  @doc """
  List commands
  """
  def list_by_system(application_id, system_name) do
    commands = from(c in Command, join: ct in ComponentType, on: ct.name == c.belongs_to_component_type, where: ct.application_id == ^application_id and ct.belongs_to_system == ^system_name) |> Repo.all()
    {:ok, commands}
  end
end
