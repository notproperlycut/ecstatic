defmodule Ecstatic.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecstatic,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ecstatic.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:commanded, "~> 1.3"},
      {:commanded_eventstore_adapter, "~> 1.2"},
      {:jason, "~> 1.2"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "event_store.setup"],
      "event_store.setup": ["event_store.create", "event_store.init"],
      "event_store.reset": ["event_store.drop", "event_store.setup"],
    ]
  end
end
