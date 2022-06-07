defmodule Mix.Tasks.Ecstatic.Init do
  @moduledoc """
  Create and initialise databases for Ecstatic.
  ## Examples
      mix ecstatic.init
  """

  use Mix.Task

  @shortdoc "Create and initialise databases for Ecstatic."
  @doc false
  def run(_args) do
    config = Ecstatic.EventStore.config()
    EventStore.Tasks.Create.exec(config)
    EventStore.Tasks.Init.exec(config)
  end
end
