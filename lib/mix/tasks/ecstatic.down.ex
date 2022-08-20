defmodule Mix.Tasks.Ecstatic.Down do
  @moduledoc """
  Destroy databases for Ecstatic.
  ## Examples
      mix ecstatic.down
  """

  use Mix.Task
  import Mix.Ecstatic

  @shortdoc "Destroy databases for Ecstatic."
  @doc false
  def run(_args) do
    args = ["-e"] ++ event_stores()
    Mix.Tasks.EventStore.Drop.run(args)

    args = ["-r"] ++ ecto_repos()
    Mix.Tasks.Ecto.Drop.run(args)
  end
end
