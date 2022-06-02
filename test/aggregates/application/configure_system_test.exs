defmodule Ecstatic.ConfigureApplication.SystemTest do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events

  test "Can add systems idempotently" do
    systems = %{
      a: [],
      b: []
    }
    assert :ok = Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems}) 

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SystemConfigured,
      fn event ->
        event.name == "system.a"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SystemConfigured,
      fn event ->
        event.name == "system.b"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    refute_receive_event(
      Ecstatic.Commanded,
      Events.SystemConfigured,
      fn -> Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems}) end
    )
  end

  test "Can remove systems" do
    systems_a = %{
      a: [],
      b: []
    }
    systems_b = %{
      a: []
    }
    assert :ok = Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems_a}) 
    assert :ok = Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems_b}) 

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SystemRemoved,
      fn event ->
        assert event.name == "system.b"
        assert event.application_id == 4
      end
    )
  end
end
