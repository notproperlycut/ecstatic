defmodule Ecstatic.Test.Aggregates.Application.Validation.System do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events

  test "Rejects periods in names" do
    good_name = "a-name_with(different*characters&and1numbers,"
    bad_name = "a-name-a.period"

    systems_good = %{
      good_name => Commands.ConfigureApplication.System.empty()
    }

    systems_bad = %{
      bad_name => Commands.ConfigureApplication.System.empty()
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               name: "4",
               systems: systems_good
             })

    refute match?(
             :ok,
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               name: "4",
               systems: systems_bad
             })
           )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SystemConfigured,
      fn event ->
        event.name == good_name
      end,
      fn event ->
        assert event.application == "4"
      end
    )
  end
end
