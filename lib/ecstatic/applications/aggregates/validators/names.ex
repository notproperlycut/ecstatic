defmodule Ecstatic.Applications.Aggregates.Validators.Names do
  alias Ecstatic.Applications.Aggregates.Validators
  @valid_name_regex ~r/\A[-0-9a-zA-Z]+\z/m

  @typenames %{
    command: "command",
    component_type: "component-type",
    event: "event",
    family: "family",
    subscription: "subscription"
  }

  def validate_all_unique(things, fieldname \\ :name) when is_list(things) do
    names = Enum.map(things, &Map.get(&1, fieldname))
    duplicates = (names -- Enum.uniq(names))
    if Enum.empty?(duplicates) do
      :ok
    else
      {:error, Enum.map(duplicates, &"The name #{&1} cannot be used more than once")}
    end

  end

  def validate_format(thing, type, fieldname \\ :name)
  def validate_format(thing, :system, fieldname) do
    name = Map.get(thing, fieldname)
    if valid_fragment?(name) do
      :ok
    else
      {:error, "#{name} is an invalid system name, alphanumeric characters and \"-\" are allowed only"}
    end
  end

  def validate_format(thing, type, fieldname) do
    name = Map.get(thing, fieldname)

    format = if valid?(name) do
      :ok
    else
      {:error, "#{name} is an invalid name, alphanumeric characters and \"-\" only, in exactly three fragments, separated by \".\""}
    end

    typename = if @typenames[type] == type(name) do
      :ok
    else
      {:error, "#{name} is not a valid name for type #{type}, expected second fragment to be \"#{@typenames[type]}\""}
    end

    Validators.collate_errors([format, typename])
  end

  def validate_share_system(thing, fieldname) do
    name = Map.get(thing, :name)
    field = Map.get(thing, fieldname)

    if system(name) == system(field) do
      :ok
    else
      {:error, "#{fieldname} of #{name} must belong to the same system, but doesn't (#{field})"}
    end
  end

  defp valid_fragment?(name) do
    name =~ @valid_name_regex
  end

  defp valid?(name) do
    parts = String.split(name, ".", parts: 3)
    Enum.all?(parts, &valid_fragment?/1)
  end

  defp type(name) do
    [_, part2, _] = String.split(name, ".", parts: 3)
    part2
  end

  defp system(name) do
    [part1 | _] = String.split(name, ".")
    part1
  end
end
