defmodule Ecstatic.Applications do
  @moduledoc """
  The boundary for the Applications system.
  """

  alias Ecstatic.Applications.Commands.{
    CreateApplication,
    DestroyApplication,
    AddSystem,
    RemoveSystem
  }

  alias Ecstatic.Applications.Projections.Application
  alias Ecstatic.App
  alias Ecstatic.Repo

  @doc """
  Create a new application.
  """
  def create(attrs \\ %{}) do
    uuid = UUID.uuid4()

    create_application = CreateApplication.new(Map.put(attrs, :id, uuid))

    with :ok <- App.dispatch(create_application, consistency: :strong) do
      {:ok, uuid}
    end
  end

  @doc """
  Destroy an application.
  """
  def destroy(attrs \\ %{}) do
    destroy_application = DestroyApplication.new(attrs)

    with :ok <- App.dispatch(destroy_application, consistency: :strong) do
      {:ok, attrs.id}
    end
  end

  @doc """
  Add a new system.
  """
  def add_system(attrs \\ %{}) do
    add_system = AddSystem.new(attrs)

    with :ok <- App.dispatch(add_system, consistency: :strong) do
      {:ok, attrs.id}
    end
  end

  @doc """
  Remove an system.
  """
  def remove_system(attrs \\ %{}) do
    remove_system = RemoveSystem.new(attrs)

    with :ok <- App.dispatch(remove_system, consistency: :strong) do
      {:ok, attrs.id}
    end
  end

  @doc """
  Get a single application by their ID
  """
  def get(id) do
    case Repo.get(Application, id) do
      nil -> {:error, :application_not_found}
      application -> {:ok, application}
    end
  end

  @doc """
  List all applications
  """
  def list() do
    applications = Repo.all(Application)
    {:ok, applications}
  end
end
