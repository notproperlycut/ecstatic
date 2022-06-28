defmodule Ecstatic.Test.Aggregates.Application.Update.Family do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events
  alias Ecstatic.Types

  test "Rejects a change of criteria" do
    has_a = "a.component.a"
    has_b = "a.component.b"

    systems_a = %{
      "a" => %Commands.ConfigureApplication.System{
        families: %{
          "b" => %Commands.ConfigureApplication.Family{
            criteria: Types.Criteria.new!(%{has: has_a})
          }
        }
      }
    }

    systems_b = %{
      "a" => %Commands.ConfigureApplication.System{
        families: %{
          "b" => %Commands.ConfigureApplication.Family{
            criteria: Types.Criteria.new!(%{has: has_b})
          }
        }
      }
    }

    assert :ok =
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{
               id: 4,
               systems: systems_a
             })

    assert_receive_event(
      Ecstatic.Commanded,
      Events.FamilyConfigured,
      fn event ->
        event.name == "a.family.b" &&
        event.criteria.has == has_a
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    refute match?(
      :ok,
      Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{
        id: 4,
        systems: systems_b
      })
    )
  end
end
