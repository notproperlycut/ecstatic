import Config

# TODO: why is this required, given that we're configuring the Commanded Application
# in lib/ecstatic/commanded.ex
config :ecstatic, event_stores: [Ecstatic.EventStore]

if Mix.env() == :test do
  config :ecstatic, :database,
  username: "postgres",
  password: "postgres",
  database: "eventstore_test",
  hostname: "localhost",
  pool_size: 1

  config :logger, level: :warn

  config :commanded,
  assert_receive_event_timeout: 100,
  refute_receive_event_timeout: 100
end
