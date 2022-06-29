defmodule Ecstatic.Test.Aggregates.Application.Validation.Criteria do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events
  alias Ecstatic.Types

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
               id: 4,
               systems: systems_good
             })

    assert_receive_event(
      Ecstatic.Commanded,
      Events.FamilyConfigured,
      fn event ->
        event.name == "a.family.b" &&
          event.criteria.has == good_criteria
      end,
      fn event ->
        assert event.application_id == 4
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
                 id: 4,
                 systems: systems_bad
               })
             )
    end)
  end
end
