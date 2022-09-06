defmodule Ecstatic.Test.Aggregates.Application.Validation.Trigger do
  use Ecstatic.DataCase

  alias Ecstatic.Commanded.Commands
  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Types

  test "Rejects invalid triggers" do
    good_trigger = "d.component.e"
    bad_trigger = ["d.foo.e", "foo"]

    systems_good = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            subscribers: %{
              "c" => %Commands.ConfigureApplication.Subscriber{
                trigger: %Types.Trigger{component: good_trigger},
                handler: Types.Handler.empty()
              }
            }
          }
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               name: "4",
               systems: systems_good
             })

    assert_receive_event(
      Ecstatic.Commanded.Application,
      Events.SubscriberConfigured,
      fn event ->
        event.name == "a.subscriber.c" &&
          event.trigger.component == good_trigger
      end,
      fn event ->
        assert event.application == "4"
      end
    )

    Enum.each(bad_trigger, fn t ->
      systems_bad = %{
        "a" => %Commands.ConfigureApplication.System{
          components: %{
            "b" => %Commands.ConfigureApplication.Component{
              schema: Types.Schema.empty(),
              subscribers: %{
                "c" => %Commands.ConfigureApplication.Subscriber{
                  trigger: %Types.Trigger{component: t},
                  handler: Types.Handler.empty()
                }
              }
            }
          }
        }
      }

      refute match?(
               :ok,
               Ecstatic.configure_application(%Commands.ConfigureApplication{
                 name: "4",
                 systems: systems_bad
               })
             )
    end)
  end
end
