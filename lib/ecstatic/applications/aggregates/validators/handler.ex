defmodule Ecstatic.Applications.Aggregates.Validators.Handler do
  @url_regex ~r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'

  def validate(thing, fieldname \\ :handler) do
    handler = Map.get(thing, fieldname)
    if valid_handler?(handler) do
      :ok
    else
      {:error, "#{thing.name} has an invalid handler"}
    end
  end

  defp valid_handler?(%{url: url}) do
    url =~ @url_regex
  end

  defp valid_handler?(nil) do
    false
  end
end
