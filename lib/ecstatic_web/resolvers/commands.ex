defmodule EcstaticWeb.Resolvers.Commands do
  def list_by_application(%{id: id}, _args, _resolution) do
    Ecstatic.Commands.list_by_application(id)
  end

  def list_by_component_type(%{application_id: application_id, name: name}, _args, _resolution) do
    Ecstatic.Commands.list_by_component_type(application_id, name)
  end

  def list_by_system(%{application_id: application_id, name: name}, _args, _resolution) do
    Ecstatic.Commands.list_by_system(application_id, name)
  end

  def get(%{application_id: application_id}, %{name: name}, _resolution) do
    Ecstatic.Commands.get(application_id, name)
  end
end
