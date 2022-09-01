defmodule Ecstatic.Test.Aggregates.Application.AddRemove.Component do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events

  test "Can add components idempotently" do
    systems = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => Commands.ConfigureApplication.Component.empty(),
          "c" => Commands.ConfigureApplication.Component.empty()
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               name: "4",
               systems: systems
             })

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ComponentConfigured,
      fn event ->
        event.name == "a.component.b"
      end,
      fn event ->
        assert event.application == "4"
      end
    )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ComponentConfigured,
      fn event ->
        event.name == "a.component.c"
      end,
      fn event ->
        assert event.application == "4"
      end
    )

    refute_receive_event(
      Ecstatic.Commanded,
      Events.ComponentConfigured,
      fn ->
        Ecstatic.configure_application(%Commands.ConfigureApplication{name: "4", systems: systems})
      end
    )
  end

  test "Can remove components" do
    systems_a = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => Commands.ConfigureApplication.Component.empty(),
          "c" => Commands.ConfigureApplication.Component.empty()
        }
      }
    }

    systems_b = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => Commands.ConfigureApplication.Component.empty()
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               name: "4",
               systems: systems_a
             })

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               name: "4",
               systems: systems_b
             })

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ComponentRemoved,
      fn event ->
        assert event.name == "a.component.c"
        assert event.application == "4"
      end
    )
  end

  test "Can remove an application" do
    systems = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => Commands.ConfigureApplication.Component.empty()
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               name: "4",
               systems: systems
             })

    assert :ok = Ecstatic.remove_application(%Commands.RemoveApplication{name: "4"})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ComponentRemoved,
      fn event ->
        assert event.name == "a.component.b"
        assert event.application == "4"
      end
    )
  end
end
