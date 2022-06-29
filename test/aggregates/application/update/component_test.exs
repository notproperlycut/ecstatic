defmodule Ecstatic.Test.Aggregates.Application.Update.Component do
  use Ecstatic.DataCase

  alias Ecstatic.Commands
  alias Ecstatic.Events
  alias Ecstatic.Types

  test "Rejects a change of schema" do
    schema_a = Jason.encode!(%{"type" => "null"})
    schema_b = Jason.encode!(%{"type" => "boolean"})

    systems_a = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.new!(%{json_schema: schema_a})
          }
        }
      }
    }

    systems_b = %{
      "a" => %Commands.ConfigureApplication.System{
        components: %{
          "b" => %Commands.ConfigureApplication.Component{
            schema: Types.Schema.new!(%{json_schema: schema_b})
          }
        }
      }
    }

    assert :ok =
             Ecstatic.configure_application(%Commands.ConfigureApplication{
               id: 4,
               systems: systems_a
             })

    assert_receive_event(
      Ecstatic.Commanded,
      Events.ComponentConfigured,
      fn event ->
        event.name == "a.component.b" &&
        event.schema.json_schema == schema_a
      end,
      fn event ->
        assert event.application_id == 4
      end
    )

    refute match?(
      :ok,
      Ecstatic.configure_application(%Commands.ConfigureApplication{
        id: 4,
        systems: systems_b
      })
    )
  end
end
