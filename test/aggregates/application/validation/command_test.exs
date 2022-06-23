defmodule Ecstatic.Test.Aggregates.Application.Validation.Command do
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
            schema: %Types.Schema{json_schema: ""},
            commands: %{
              good_name => %Commands.ConfigureApplication.Command{
                schema: %Types.Schema{json_schema: ""},
                handler: %Types.Handler{mfa: ""}
              }
            }
          }
        }
      }
    }

    systems_bad = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: %Types.Schema{json_schema: ""},
            commands: %{
              bad_name => %Commands.ConfigureApplication.Command{
                schema: %Types.Schema{json_schema: ""},
                handler: %Types.Handler{mfa: ""}
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

    refute match?(
             :ok,
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{
               id: 4,
               systems: systems_bad
             })
           )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.CommandConfigured,
      fn event ->
        event.name == "a.command.#{good_name}"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )
  end
end
