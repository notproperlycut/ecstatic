defmodule Ecstatic.Test.Aggregates.Application.Validation.Criteria do
  use Ecstatic.DataCase

  alias Ecstatic.Commanded.Commands
  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Types

  test "Rejects invalid criteria" do
    good_criteria = "d.component.e"
    bad_criteria = ["d.event.e", "", "foo"]

    systems_good = %{
      "a" => %Commands.ConfigureApplication.System{
        families: %{
          "b" => %Commands.ConfigureApplication.Family{
            criteria: Types.Criteria.new!(%{has: good_criteria})
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
      Events.FamilyConfigured,
      fn event ->
        event.name == "a.family.b" &&
          event.criteria.has == good_criteria
      end,
      fn event ->
        assert event.application == "4"
      end
    )

    Enum.each(bad_criteria, fn c ->
      systems_bad = %{
        "a" => %Commands.ConfigureApplication.System{
          families: %{
            "b" => %Commands.ConfigureApplication.Family{
              criteria: %Types.Criteria{has: c}
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
