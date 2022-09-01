defmodule Ecstatic.Test.Aggregates.Application.AddRemove.Application do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events

  test "Can configure a new application idempotently" do
    assert :ok = Ecstatic.configure_application(%Commands.ConfigureApplication{name: "4"})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ApplicationConfigured,
      fn event -> assert event.name == "4" end
    )

    refute_receive_event(
      Ecstatic.Commanded,
      Events.ApplicationConfigured,
      fn -> Ecstatic.configure_application(%Commands.ConfigureApplication{name: "4"}) end
    )
  end

  test "Can remove an application" do
    assert :ok = Ecstatic.configure_application(%Commands.ConfigureApplication{name: "4"})
    assert :ok = Ecstatic.remove_application(%Commands.RemoveApplication{name: "4"})

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ApplicationRemoved,
      fn event -> assert event.name == "4" end
    )

    refute_receive_event(
      Ecstatic.Commanded,
      Events.ApplicationRemoved,
      fn -> Ecstatic.remove_application(%Commands.RemoveApplication{name: "4"}) end
    )
  end

  test "Cannot remove an non-existent application" do
    assert :ok = Ecstatic.configure_application(%Commands.ConfigureApplication{name: "4"})

    assert {:error, :no_such_application} =
             Ecstatic.remove_application(%Commands.RemoveApplication{name: 3})
  end

  test "Cannot use a removed application" do
    :ok = Ecstatic.configure_application(%Commands.ConfigureApplication{name: "4"})
    :ok = Ecstatic.remove_application(%Commands.RemoveApplication{name: "4"})

    assert {:error, :removed_application} =
             Ecstatic.configure_application(%Commands.ConfigureApplication{name: "4"})

    assert {:error, :removed_application} =
             Ecstatic.remove_application(%Commands.RemoveApplication{name: "4"})
  end
end
