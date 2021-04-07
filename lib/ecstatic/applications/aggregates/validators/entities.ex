defmodule Ecstatic.Applications.Aggregates.Validators.Entities do
  alias Ecstatic.Applications.Aggregates.Validators

  def validate_exists(name, application, entity_types) when is_list(entity_types) do
    found = Enum.map(entity_types, &validate_exists(name, application, &1))
    |> Validators.any_ok?()

    if found do
      :ok
    else
      {:error, "#{name} was not found among objects of types [#{Enum.join(entity_types, ", ")}]"}
    end
  end

  def validate_exists(name, application, entity_type) do
    candidates = Map.get(application, entity_type)
    if get_item(candidates, name) do
      :ok
    else
      {:error, "#{name} was not found among objects of type #{entity_type}"}
    end
  end

  def validate_relation(thing, fieldname, application, relation_types) when is_list(relation_types) do
    found = Enum.map(relation_types, &validate_relation(thing, fieldname, application, &1))
    |> Validators.any_ok?()

    if found do
      :ok
    else
      relation_name = Map.get(thing, fieldname)
      {:error, "#{fieldname} of #{thing.name} (#{relation_name}) was not found among objects of types [#{Enum.join(relation_types, ", ")}]"}
    end
  end

  def validate_relation(thing, fieldname, application, relation_type) do
    relation_name = Map.get(thing, fieldname)
    case validate_exists(relation_name, application, relation_type) do
      :ok -> :ok
      _ -> {:error, "#{fieldname} of #{thing.name} (#{relation_name}) was not found among objects of type #{relation_type}"}
    end
  end

  defp get_item(collection, name) do
    Enum.find(collection, false, fn item -> item.name == name end)
  end
end
