defmodule Ecstatic.Test.Aggregates.Application.Validation.Component do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events

  test "Rejects periods in names" do
    good_name = "a-name_with(different*characters&and1numbers,"
    bad_name = "a-name-a.period"

    systems_good = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          good_name => Commands.ConfigureApplication.Component.empty()
        }
      }
    }

    systems_bad = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          bad_name => Commands.ConfigureApplication.Component.empty()
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: 4,
               systems: systems_good
             })

    refute match?(
             :ok,
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: 4,
               systems: systems_bad
             })
           )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ComponentConfigured,
      fn event ->
        event.name == "a.component.#{good_name}"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )
  end
end
