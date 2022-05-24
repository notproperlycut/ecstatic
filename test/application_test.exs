defmodule Ecstatic.ApplicationTest do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events

  test "Can configure a new application" do
    assert :ok = Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ApplicationConfigured,
      fn event -> assert event.id == 4 end
    )
  end

  test "Can remove an application" do
    assert :ok = Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4})
    assert :ok = Ecstatic.Commanded.dispatch(%Commands.RemoveApplication{id: 4})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ApplicationRemoved,
      fn event -> assert event.id == 4 end
    )
  end

  test "Cannot remove an non-existent application" do
    assert :ok = Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4})
    assert {:error, :no_such_application} = Ecstatic.Commanded.dispatch(%Commands.RemoveApplication{id: 3})
  end

  test "Cannot use a removed application" do
    :ok = Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4})
    :ok = Ecstatic.Commanded.dispatch(%Commands.RemoveApplication{id: 4})
    assert {:error, :removed_application} = Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4})
    assert {:error, :removed_application} = Ecstatic.Commanded.dispatch(%Commands.RemoveApplication{id: 4})
  end
end
