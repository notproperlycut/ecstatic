defmodule Ecstatic.Test.Aggregates.Application.Validation.Family do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events

  test "Rejects periods in names" do
    good_name = "a-name_with(different*characters&and1numbers,"
    bad_name = "a-name-a.period"

    systems_good = %{
      "a" => %Commands.ConfigureApplication.System{
        families: %{
          good_name => Commands.ConfigureApplication.Family.empty()
        }
      }
    }

    systems_bad = %{
      "a" => %Commands.ConfigureApplication.System{
        families: %{
          bad_name => Commands.ConfigureApplication.Family.empty()
        }
      }
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
      Events.FamilyConfigured,
      fn event ->
        event.name == "a.family.#{good_name}"
      end,
      fn event ->
        assert event.application == "4"
      end
    )
  end
end
