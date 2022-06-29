defmodule Mix.Tasks.Ecstatic.Drop do
  @moduledoc """
  Destroy databases for Ecstatic.
  ## Examples
      mix ecstatic.drop
  """

  use Mix.Task

  @shortdoc "Destroy databases for Ecstatic."
  @doc false
  def run(_args) do
    config = Ecstatic.EventStore.config()
    EventStore.Tasks.Drop.exec(config)
  end
end
