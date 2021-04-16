defmodule EcstaticWeb.Resolvers.Systems do
  def add(_parent, %{input: input}, %{context: %{scope: :admin}}) do
    input = Map.put(input, :id, input.application_id)

    with {:ok, id} <- Ecstatic.Applications.add_system(input),
         {:ok, application} <- Ecstatic.Applications.get(id) do
      {:ok, %{application: application}}
    end
  end

  def add(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def remove(_parent, %{input: input}, %{context: %{scope: :admin}}) do
    input = Map.put(input, :id, input.application_id)

    with {:ok, id} <- Ecstatic.Applications.remove_system(input),
         {:ok, application} <- Ecstatic.Applications.get(id) do
      {:ok, %{application: application}}
    end
  end

  def remove(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
