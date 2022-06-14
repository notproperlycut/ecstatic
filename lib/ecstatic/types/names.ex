defmodule Ecstatic.Types.Names do
  import Domo

  @type t() :: String.t()
  precond t: &validate_characters/1

  defp validate_characters(name) do
    if name =~ ~r/\./ do
      {:error, "Names cannot contain a '.' (period)"}
    else
      :ok
    end
  end
end
