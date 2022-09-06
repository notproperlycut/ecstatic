defmodule Mix.Ecstatic do
  def event_stores() do
    ["Ecstatic.Commanded.EventStore"]
  end

  def ecto_repos() do
    ["Ecstatic.Commanded.Repo"]
  end
end
