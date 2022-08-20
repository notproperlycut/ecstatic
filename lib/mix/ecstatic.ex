defmodule Mix.Ecstatic do
  def event_stores() do
    ["Ecstatic.EventStore"]
  end

  def ecto_repos() do
    ["Ecstatic.Repo"]
  end
end
