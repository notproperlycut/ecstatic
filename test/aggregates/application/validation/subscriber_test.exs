defmodule Ecstatic.Test.Aggregates.Application.Validation.Subscriber do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events
  alias Ecstatic.Types

  test "Rejects periods in names" do
    good_name = "a-name_with(different*characters&and1numbers,"
    bad_name = "a-name-a.period"

    systems_good = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            subscribers: %{
              good_name => Commands.ConfigureApplication.Subscriber.empty()
            }
          }
        }
      }
    }

    systems_bad = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            subscribers: %{
              bad_name => Commands.ConfigureApplication.Subscriber.empty()
            }
          }
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: "4",
               systems: systems_good
             })

    refute match?(
             :ok,
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: "4",
               systems: systems_bad
             })
           )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberConfigured,
      fn event ->
        event.name == "a.subscriber.#{good_name}"
      end,
      fn event ->
        assert event.application_id == "4"
        assert event.component_name == "a.component.b"
      end
    )
  end

  test "Rejects duplicate names" do
    systems_good = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            subscribers: %{
              "d" => Commands.ConfigureApplication.Subscriber.empty()
            }
          },
          "c" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            subscribers: %{
              "e" => Commands.ConfigureApplication.Subscriber.empty()
            }
          }
        }
      }
    }

    systems_bad = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            subscribers: %{
              "d" => Commands.ConfigureApplication.Subscriber.empty()
            }
          },
          "c" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            subscribers: %{
              "d" => Commands.ConfigureApplication.Subscriber.empty()
            }
          }
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: "4",
               systems: systems_good
             })

    refute match?(
             :ok,
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: "4",
               systems: systems_bad
             })
           )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberConfigured,
      fn event ->
        event.name == "a.subscriber.d"
      end,
      fn event ->
        assert event.application_id == "4"
        assert event.component_name == "a.component.b"
      end
    )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberConfigured,
      fn event ->
        event.name == "a.subscriber.e"
      end,
      fn event ->
        assert event.application_id == "4"
        assert event.component_name == "a.component.c"
      end
    )
  end
end
