defmodule Mix.Tasks.Ecstatic.Up do
  @moduledoc """
  Create and initialise databases for Ecstatic.
  ## Examples
      mix ecstatic.up
  """

  use Mix.Task
  import Mix.Ecstatic

  @shortdoc "Create and initialise databases for Ecstatic."
  @doc false
  def run(_args) do
    args = ["-e"] ++ event_stores()
    Mix.Tasks.EventStore.Create.run(args)
    Mix.Tasks.EventStore.Init.run(args)

    args = ["-r"] ++ ecto_repos()
    Mix.Tasks.Ecto.Create.run(args)
    Mix.Tasks.Ecto.Migrate.run(args)
  end
end
