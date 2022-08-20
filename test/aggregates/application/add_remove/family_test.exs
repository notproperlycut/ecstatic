defmodule Ecstatic.Test.Aggregates.Application.AddRemove.Family do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events

  test "Can add families idempotently" do
    systems = %{
      "a" => %Commands.ConfigureApplication.System{
        families: %{
          "b" => Commands.ConfigureApplication.Family.empty(),
          "c" => Commands.ConfigureApplication.Family.empty()
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: "4",
               systems: systems
             })

    assert_receive_event(
      Ecstatic.Commanded,
      Events.FamilyConfigured,
      fn event ->
        event.name == "a.family.b"
      end,
      fn event ->
        assert event.application_id == "4"
      end
    )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.FamilyConfigured,
      fn event ->
        event.name == "a.family.c"
      end,
      fn event ->
        assert event.application_id == "4"
      end
    )

    refute_receive_event(
      Ecstatic.Commanded,
      Events.FamilyConfigured,
      fn ->
        Ecstatic.configure_application(%Commands.ConfigureApplication{id: "4", systems: systems})
      end
    )
  end

  test "Can remove families" do
    systems_a = %{
      "a" => %Commands.ConfigureApplication.System{
        families: %{
          "b" => Commands.ConfigureApplication.Family.empty(),
          "c" => Commands.ConfigureApplication.Family.empty()
        }
      }
    }

    systems_b = %{
      "a" => %Commands.ConfigureApplication.System{
        families: %{
          "b" => Commands.ConfigureApplication.Family.empty()
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: "4",
               systems: systems_a
             })

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: "4",
               systems: systems_b
             })

    assert_receive_event(
      Ecstatic.Commanded,
      Events.FamilyRemoved,
      fn event ->
        assert event.name == "a.family.c"
        assert event.application_id == "4"
      end
    )
  end

  test "Can remove an application" do
    systems = %{
      "a" => %Commands.ConfigureApplication.System{
        families: %{
          "b" => Commands.ConfigureApplication.Family.empty()
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: "4",
               systems: systems
             })

    assert :ok = Ecstatic.remove_application(%Commands.RemoveApplication{id: "4"})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.FamilyRemoved,
      fn event ->
        assert event.name == "a.family.b"
        assert event.application_id == "4"
      end
    )
  end
end
