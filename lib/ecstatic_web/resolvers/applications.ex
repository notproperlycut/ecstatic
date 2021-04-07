defmodule EcstaticWeb.Resolvers.Applications do
  def list(_parent, _args, _resolution) do
    Ecstatic.Applications.list()
  end

  def get(_parent, %{id: id}, _resolution) do
    Ecstatic.Applications.get(id)
  end

  def get(%{application_id: application_id}, _args, _resolution) do
    Ecstatic.Applications.get(application_id)
  end

  def create(_parent, %{input: input}, %{context: %{scope: :admin}}) do
    with {:ok, id} <- Ecstatic.Applications.create(input),
         {:ok, application} <- Ecstatic.Applications.get(id) do
      {:ok, %{application: application}}
    end
  end

  def create(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def destroy(_parent, %{input: input}, %{context: %{scope: :admin}}) do
    with {:ok, id} <- Ecstatic.Applications.destroy(input) do
      {:ok, %{id: id}}
    end
  end

  def destroy(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
