defmodule EcstaticWeb.Resolvers.Engines do
  def list_engines(_parent, _args, _resolution) do
    Ecstatic.Engines.list_engines()
  end

  def get_engine(_parent, %{id: id}, _resolution) do
    Ecstatic.Engines.engine_by_engine_id(id)
  end

  def create_engine(_parent, %{input: input}, %{context: %{scope: :admin}}) do
    with {:ok, engine_id} <- Ecstatic.Engines.create_engine(input),
         {:ok, engine} <- Ecstatic.Engines.engine_by_engine_id(engine_id) do
      {:ok, %{engine: engine}}
    end
  end

  def create_engine(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def destroy_engine(_parent, %{input: input}, %{context: %{scope: :admin}}) do
    with {:ok, engine_id} <- Ecstatic.Engines.destroy_engine(input) do
      {:ok, %{engine_id: engine_id}}
    end
  end

  def destroy_engine(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
