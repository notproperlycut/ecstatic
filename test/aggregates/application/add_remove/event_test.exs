defmodule Ecstatic.Test.Aggregates.Application.AddRemove.Event do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events
  alias Ecstatic.Types

  test "Can add events idempotently" do
    systems = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            events: %{
              "c" => %Commands.ConfigureApplication.Event{
                schema: Types.Schema.empty(),
                handler: Types.Handler.empty()
              },
              "d" => %Commands.ConfigureApplication.Event{
                schema: Types.Schema.empty(),
                handler: Types.Handler.empty()
              }
            }
          }
        }
      }
    }

    assert :ok =
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.EventConfigured,
      fn event ->
        event.name == "a.event.c"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.EventConfigured,
      fn event ->
        event.name == "a.event.d"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    refute_receive_event(
      Ecstatic.Commanded,
      Events.EventConfigured,
      fn ->
        Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems})
      end
    )
  end

  test "Can remove events" do
    systems_a = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            events: %{
              "c" => %Commands.ConfigureApplication.Event{
                schema: Types.Schema.empty(),
                handler: Types.Handler.empty()
              },
              "d" => %Commands.ConfigureApplication.Event{
                schema: Types.Schema.empty(),
                handler: Types.Handler.empty()
              }
            }
          }
        }
      }
    }

    systems_b = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            events: %{
              "c" => %Commands.ConfigureApplication.Event{
                schema: Types.Schema.empty(),
                handler: Types.Handler.empty()
              }
            }
          }
        }
      }
    }

    assert :ok =
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems_a})

    assert :ok =
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems_b})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.EventRemoved,
      fn event ->
        assert event.name == "a.event.d"
        assert event.application_id == 4
      end
    )
  end

  test "Can remove an application" do
    systems = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            events: %{
              "c" => %Commands.ConfigureApplication.Event{
                schema: Types.Schema.empty(),
                handler: Types.Handler.empty()
              }
            }
          }
        }
      }
    }

    assert :ok =
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems})

    assert :ok = Ecstatic.Commanded.dispatch(%Commands.RemoveApplication{id: 4})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.EventRemoved,
      fn event ->
        assert event.name == "a.event.c"
        assert event.application_id == 4
      end
    )
  end
end
