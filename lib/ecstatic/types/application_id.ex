defmodule Ecstatic.Types.ApplicationId do
  import Domo

  @type t() :: String.t()
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end
