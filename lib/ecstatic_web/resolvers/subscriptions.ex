defmodule EcstaticWeb.Resolvers.Subscriptions do
  def list_by_application(%{id: id}, _args, _resolution) do
    Ecstatic.Events.list_by_application(id)
  end

  def list_by_component_type(%{application_id: application_id, name: name}, _args, _resolution) do
    Ecstatic.Events.list_by_component_type(application_id, name)
  end

  def list_by_system(%{application_id: application_id, name: name}, _args, _resolution) do
    Ecstatic.Events.list_by_system(application_id, name)
  end

  def get(%{application_id: application_id}, %{name: name}, _resolution) do
    Ecstatic.Subscriptions.get(application_id, name)
  end
end
