defmodule Ecstatic.Engines do
  @moduledoc """
  The boundary for the Engines system.
  """

  alias Ecstatic.Engines.Commands.{CreateEngine, DestroyEngine}
  alias Ecstatic.App

  @doc """
  Create a new engine.
  """
  def create_engine(attrs \\ %{}) do
    uuid = UUID.uuid4()

    create_engine = CreateEngine.new(Map.put(attrs, :engine_id, uuid))

    with :ok <- App.dispatch(create_engine) do
      {:ok, uuid}
    end
  end

  @doc """
  Destroy an engine.
  """
  def destroy_engine(attrs \\ %{}) do
    destroy_engine = DestroyEngine.new(attrs)

    with :ok <- App.dispatch(destroy_engine) do
      {:ok}
    end
  end
end
