defmodule Ecstatic.Test.Aggregates.Application.AddRemove.Subscriber do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events
  alias Ecstatic.Types

  test "Can add subscribers idempotently" do
    systems = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            subscribers: %{
              "c" => Commands.ConfigureApplication.Subscriber.empty(),
              "d" => Commands.ConfigureApplication.Subscriber.empty()
            }
          }
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: 4,
               systems: systems
             })

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberConfigured,
      fn event ->
        event.name == "a.subscriber.c"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberConfigured,
      fn event ->
        event.name == "a.subscriber.d"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    refute_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberConfigured,
      fn ->
        Ecstatic.configure_application(%Commands.ConfigureApplication{id: 4, systems: systems})
      end
    )
  end

  test "Can remove subscribers" do
    systems_a = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            subscribers: %{
              "c" => Commands.ConfigureApplication.Subscriber.empty(),
              "d" => Commands.ConfigureApplication.Subscriber.empty()
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
            subscribers: %{
              "c" => Commands.ConfigureApplication.Subscriber.empty()
            }
          }
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: 4,
               systems: systems_a
             })

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: 4,
               systems: systems_b
             })

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberRemoved,
      fn event ->
        assert event.name == "a.subscriber.d"
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
            subscribers: %{
              "c" => Commands.ConfigureApplication.Subscriber.empty()
            }
          }
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: 4,
               systems: systems
             })

    assert :ok = Ecstatic.remove_application(%Commands.RemoveApplication{id: 4})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberRemoved,
      fn event ->
        assert event.name == "a.subscriber.c"
        assert event.application_id == 4
      end
    )
  end
end
