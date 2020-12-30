defmodule Ecstatic.Engines do
  @moduledoc """
  The boundary for the Engines system.
  """

  alias Ecstatic.Engines.Commands.{CreateEngine, DestroyEngine}
  alias Ecstatic.Engines.Projections.Engine
  alias Ecstatic.App
  alias Ecstatic.Repo

  @doc """
  Create a new engine.
  """
  def create_engine(attrs \\ %{}) do
    uuid = UUID.uuid4()

    create_engine = CreateEngine.new(Map.put(attrs, :engine_id, uuid))

    with :ok <- App.dispatch(create_engine, consistency: :strong) do
      {:ok, uuid}
    end
  end

  @doc """
  Destroy an engine.
  """
  def destroy_engine(attrs \\ %{}) do
    destroy_engine = DestroyEngine.new(attrs)

    with :ok <- App.dispatch(destroy_engine, consistency: :strong) do
      {:ok, attrs.engine_id}
    end
  end

  @doc """
  Get a single engine by their ID
  """
  def engine_by_engine_id(engine_id) do
    case Repo.get(Engine, engine_id) do
      nil -> {:error, :engine_not_found}
      engine -> {:ok, engine}
    end
  end

  @doc """
  Get a single engine by their ID
  """
  def list_engines() do
    engines = Repo.all(Engine)
    {:ok, engines}
  end
end
