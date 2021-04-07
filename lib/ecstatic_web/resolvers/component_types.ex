defmodule EcstaticWeb.Resolvers.ComponentTypes do
  def list_by_application(%{id: id}, _args, _resolution) do
    Ecstatic.ComponentTypes.list_by_application(id)
  end

  def list_by_system(%{application_id: application_id, name: name}, _args, _resolution) do
    Ecstatic.ComponentTypes.list_by_system(application_id, name)
  end

  def get(%{application_id: application_id}, %{name: name}, _resolution) do
    Ecstatic.ComponentTypes.get(application_id, name)
  end
end
