defmodule Ecstatic.Test.Aggregates.Application.AddRemove.Command do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events

  test "Can add commands idempotently" do
    systems = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            commands: %{
              "c" => [],
              "d" => []
            }
          }
        }
      }
    }

    assert :ok =
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.CommandConfigured,
      fn event ->
        event.name == "a.command.c"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.CommandConfigured,
      fn event ->
        event.name == "a.command.d"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    refute_receive_event(
      Ecstatic.Commanded,
      Events.CommandConfigured,
      fn ->
        Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems})
      end
    )
  end

  test "Can remove commands" do
    systems_a = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            commands: %{
              "c" => [],
              "d" => []
            }
          }
        }
      }
    }

    systems_b = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            commands: %{
              "c" => []
            }
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
      Events.CommandRemoved,
      fn event ->
        assert event.name == "a.command.d"
        assert event.application_id == 4
      end
    )
  end

  test "Can remove an application" do
    systems = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            commands: %{
              "c" => []
            }
          }
        }
      }
    }

    assert :ok =
             Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems})

    assert :ok = Ecstatic.Commanded.dispatch(%Commands.RemoveApplication{id: 4})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.CommandRemoved,
      fn event ->
        assert event.name == "a.command.c"
        assert event.application_id == 4
      end
    )
  end
end
