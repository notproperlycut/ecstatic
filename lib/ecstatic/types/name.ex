defmodule Ecstatic.Types.Name do
  @name_classes [:family, :component, :command, :event, :subscriber]

  def long(system, class, name) when class in @name_classes do
    case {classify(system), classify(name)} do
      {_, %{type: :long}} ->
        {:ok, name}
      {%{type: :short, name: sname}, %{type: :short, name: name}} ->
        {:ok, "#{sname}.#{class}.#{name}"}
      {%{type: :long, system: sname}, %{type: :short, name: name}}->
        {:ok, "#{sname}.#{class}.#{name}"}
      _ ->
        {:error, :invalid_names_supplied}
    end
  end

  def short(name) do
    case classify(name) do
      %{type: :short, name: name} ->
        {:ok, name}
      %{type: :long, name: name} ->
        {:ok, name}
      _ ->
        {:error, :invalid_system_supplied}
    end
  end

  def classify(name) when is_binary(name) do
    case partition(name) do
      [name] ->
        %{type: :short, name: name}
      [system, class, name] when class in @name_classes ->
        %{type: :long, system: system, class: class, name: name}
      _ ->
        %{type: :not_a_name}
    end

  end

  defp partition(name) do
    fragments = String.split(name, ".")

    try do
      List.update_at(fragments, 1, &String.to_existing_atom/1)
    rescue
      _ -> []
    end
  end
end
