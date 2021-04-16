defmodule Ecstatic.Applications.Aggregates.Validators.Entities do
  alias Ecstatic.Applications.Aggregates.Validators

  def validate_exists_by_name(name, application, entity_types) when is_list(entity_types) do
    found =
      Enum.map(entity_types, &validate_exists_by_name(name, application, &1))
      |> Validators.any_ok?()

    if found do
      :ok
    else
      {:error, "#{name} was not found among objects of types [#{Enum.join(entity_types, ", ")}]"}
    end
  end

  def validate_exists_by_name(name, application, entity_type) do
    if get_item_by_name(name, application, entity_type) do
      :ok
    else
      {:error, "#{name} was not found among objects of type #{entity_type}"}
    end
  end

  def get_item_by_name(name, application, entity_type) do
    collection = Map.get(application, entity_type)
    Enum.find(collection, false, fn item -> item.name == name end)
  end

  def get_item_by_id(id, application, entity_type) do
    collection = Map.get(application, entity_type)
    Enum.find(collection, false, fn item -> item.id == id end)
  end
end
