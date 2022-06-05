defmodule Ecstatic.ConfigureApplication.SubscriberTest do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events

  test "Can add subscribers idempotently" do
    systems = %{
      a: %Commands.ConfigureApplication.System{
        components: %{
          b: %Commands.ConfigureApplication.Component{
              subscribers: %{
                c: [],
                d: [],
              }
          }
        }
      }
    }
    assert :ok = Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems}) 

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberConfigured,
      fn event ->
        event.name == "a.subscriber.c"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberConfigured,
      fn event ->
        event.name == "a.subscriber.d"
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    refute_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberConfigured,
      fn -> Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems}) end
    )
  end

  test "Can remove subscribers" do
    systems_a = %{
      a: %Commands.ConfigureApplication.System{
        components: %{
          b: %Commands.ConfigureApplication.Component{
              subscribers: %{
                c: [],
                d: [],
              }
          }
        }
      }
    }

    systems_b = %{
      a: %Commands.ConfigureApplication.System{
        components: %{
          b: %Commands.ConfigureApplication.Component{
              subscribers: %{
                c: []
              }
          }
        }
      }
    }
    assert :ok = Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems_a}) 
    assert :ok = Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems_b}) 

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberRemoved,
      fn event ->
        assert event.name == "a.subscriber.d"
        assert event.application_id == 4
      end
    )
  end

  test "Can remove an application" do
    systems = %{
      a: %Commands.ConfigureApplication.System{
        components: %{
          b: %Commands.ConfigureApplication.Component{
              subscribers: %{
                c: []
              }
          }
        }
      }
    }
    assert :ok = Ecstatic.Commanded.dispatch(%Commands.ConfigureApplication{id: 4, systems: systems}) 
    assert :ok = Ecstatic.Commanded.dispatch(%Commands.RemoveApplication{id: 4}) 

    assert_receive_event(
      Ecstatic.Commanded,
      Events.SubscriberRemoved,
      fn event ->
        assert event.name == "a.subscriber.c"
        assert event.application_id == 4
      end
    )
  end
end
