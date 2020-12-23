defmodule EcstaticWeb.Resolvers.Engines do
  def list_engines(_parent, _args, _resolution) do
    {:ok, []}
    # {:ok, Ecstatic.Engines.list_engines()}
  end

  def create_engine(_parent, args, %{context: %{scope: :admin}}) do
    Ecstatic.Engines.create_engine(args)
  end

  def create_engine(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def destroy_engine(_parent, args, %{context: %{scope: :admin}}) do
    Ecstatic.Engines.destroy_engine(args)
  end

  def destroy_engine(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
