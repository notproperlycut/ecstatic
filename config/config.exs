import Config

config :ecstatic, ecto_repos: [Ecstatic.Repo]
config :ecstatic, event_stores: [Ecstatic.EventStore]

if Mix.env() == :test do
  config :ecstatic, :database,
    username: "postgres",
    password: "postgres",
    database: "ecstatic_test",
    hostname: "localhost",
    pool_size: 2

  config :logger, level: :warn

  config :commanded,
    assert_receive_event_timeout: 100,
    refute_receive_event_timeout: 100
end
