defmodule Ecstatic.MixProject do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      app: :ecstatic,
      compilers: [:domo_compiler] ++ Mix.compilers(),
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]],
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      test_coverage: [ignore_modules: [~r/\.TypeEnsurer$/]],
      version: "0.1.0"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto],
      mod: {Ecstatic.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:commanded, "~> 1.3"},
      {:commanded_eventstore_adapter, "~> 1.2"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:domo, "~> 1.5"},
      {:elixir_uuid, "~> 1.2"},
      {:jason, "~> 1.2"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "event_store.setup"],
      "event_store.setup": ["event_store.create", "event_store.init"],
      "event_store.reset": ["event_store.drop", "event_store.setup"],
      reset: ["event_store.reset"],
      test: ["reset", "test"]
    ]
  end
end
