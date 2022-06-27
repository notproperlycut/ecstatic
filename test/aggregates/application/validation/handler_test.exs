defmodule Ecstatic.Test.Aggregates.Application.Validation.Handler do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events
  alias Ecstatic.Types

  def handler(_) do
    {:ok, []}
  end

  test "Rejects invalid schema" do
    good_mfa = [to_string(__MODULE__), "handler", 1]
    bad_mfa = []

    systems_good = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.empty(),
            events: %{
              "c" => %Commands.ConfigureApplication.Event{
                schema: Types.Schema.empty(),
                handler: %Types.Handler{mfa: good_mfa}
              }
            }
          }
        }
      }
    }

    assert :ok =
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{
               id: 4,
               systems: systems_good
             })

    assert_receive_event(
      Ecstatic.Commanded,
      Events.EventConfigured,
      fn event ->
        event.name == "a.event.c" &&
          event.handler.mfa == good_mfa
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    Enum.each(bad_mfa, fn m ->
      systems_bad = %{
        "a" => %Commands.ConfigureApplication.System{
          components: %{
            "b" => %Commands.ConfigureApplication.Component{
              schema: Types.Schema.empty(),
              events: %{
                "c" => %Commands.ConfigureApplication.Event{
                  schema: Types.Schema.empty(),
                  handler: %Types.Handler{mfa: m}
                }
              }
            }
          }
        }
      }

      refute match?(
               :ok,
               Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{
                 id: 4,
                 systems: systems_bad
               })
             )
    end)
  end
end
