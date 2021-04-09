defmodule EcstaticWeb.Resolvers.Families do
  def list_by_application(%{id: id}, _args, _resolution) do
    Ecstatic.Families.list_by_application(id)
  end

  def list_by_system(%{application_id: application_id, name: name}, _args, _resolution) do
    Ecstatic.Families.list_by_system(application_id, name)
  end

  def get(%{application_id: application_id}, %{name: name}, _resolution) do
    Ecstatic.Families.get(application_id, name)
  end
end
