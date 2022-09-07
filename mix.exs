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
      mod: {Ecstatic.Otp.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:commanded, "~> 1.3"},
      {:commanded_ecto_projections, "~> 1.2"},
      {:commanded_eventstore_adapter, "~> 1.2"},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:domo, "~> 1.5"},
      {:ecto_sql, "~> 3.0"},
      {:elixir_uuid, "~> 1.2"},
      {:ex_json_schema, "~> 0.9.1"},
      {:jason, "~> 1.2"},
      {:nestru, "~> 0.2.1"},
      {:postgrex, ">= 0.0.0"},
      {:typed_struct, "~> 0.3.0"}
    ]
  end

  defp aliases do
    [
      up: ["deps.get", "ecstatic.up"],
      down: ["ecstatic.down"],
      test: ["up", "test"]
    ]
  end
end
