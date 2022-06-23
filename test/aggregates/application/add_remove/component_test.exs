defmodule Ecstatic.Test.Aggregates.Application.AddRemove.Component do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events
  alias Ecstatic.Types

  test "Can add components idempotently" do
    systems = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: %Types.Schema{json_schema: ""}
          },
          "c" => %Commands.ConfigureApplication.Component{
            schema: %Types.Schema{json_schema: ""}
          }
        }
      }
    }

    assert :ok =
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ComponentConfigured,
      fn event ->
        event.name == "a.component.b"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ComponentConfigured,
      fn event ->
        event.name == "a.component.c"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    refute_receive_event(
      Ecstatic.Commanded,
      Events.ComponentConfigured,
      fn ->
        Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems})
      end
    )
  end

  test "Can remove components" do
    systems_a = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: %Types.Schema{json_schema: ""}
          },
          "c" => %Commands.ConfigureApplication.Component{
            schema: %Types.Schema{json_schema: ""}
          }
        }
      }
    }

    systems_b = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: %Types.Schema{json_schema: ""}
          }
        }
      }
    }

    assert :ok =
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems_a})

    assert :ok =
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems_b})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ComponentRemoved,
      fn event ->
        assert event.name == "a.component.c"
        assert event.application_id == 4
      end
    )
  end

  test "Can remove an application" do
    systems = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: %Types.Schema{json_schema: ""}
          }
        }
      }
    }

    assert :ok =
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems})

    assert :ok = Ecstatic.Commanded.dispatch(%Commands.RemoveApplication{id: 4})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ComponentRemoved,
      fn event ->
        assert event.name == "a.component.b"
        assert event.application_id == 4
      end
    )
  end
end
