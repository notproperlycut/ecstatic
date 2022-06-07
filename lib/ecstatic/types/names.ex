defmodule Ecstatic.Types.Names do
  import Domo

  @type t :: String.t()
  precond(t: &validate/1)

  def validate(name) do
    if name =~ ~r/\./ do
      {:error, "Names cannot contain a '.' (period)"}
    else
      :ok
    end
  end
end
