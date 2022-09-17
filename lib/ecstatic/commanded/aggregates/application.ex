defmodule Ecstatic.Commanded.Aggregates.Application do
  use TypedStruct

  typedstruct do
    field :state, atom(), default: nil
    field :configuration, Ecstatic.Application.Configuration.t(), default: nil
  end

  alias Ecstatic.Commanded.Aggregates.Application
  alias Ecstatic.Commanded.Commands
  alias Ecstatic.Commanded.Events

  #
  def execute(%Application{state: :removed}, _) do
    {:error, :removed_application}
  end

  def execute(%Application{state: nil}, %Commands.Application.Configure{name: name, configuration: configuration}) do
    with {:ok, events} <- Ecstatic.Commanded.Aggregates.Application.Configuration.add(name, configuration) do
      add = %Events.Application.Added{
        name: name,
        configuration: configuration
      }
      [add | events]
    end
  end

  def execute(%Application{configuration: configuration}, %Commands.Application.Configure{configuration: configuration}) do
    :ok
  end

  def execute(%Application{configuration: existing}, %Commands.Application.Configure{name: name, configuration: configuration}) do
    with {:ok, events} <- Ecstatic.Commanded.Aggregates.Application.Configuration.update(name, existing, configuration) do
      update = %Events.Application.Updated{
        name: name,
        configuration: configuration
      }
      [update | events]
    end
  end

  def execute(%Application{state: nil}, _) do
    {:error, :no_such_application}
  end

  def execute(%Application{configuration: existing}, %Commands.Application.Remove{name: name}) do
    with {:ok, events} <- Ecstatic.Commanded.Aggregates.Application.Configuration.remove(name, existing) do
      remove = %Events.Application.Removed{
        name: name,
        configuration: existing
      }
      [remove | events]
    end
  end

  #
  def apply(%Application{state: :removed}, _) do
    %Application{state: :removed}
  end

  def apply(%Application{}, %Events.Application.Removed{}) do
    %Application{state: :removed}
  end

  def apply(%Application{} = app, %Events.Application.Added{configuration: configuration}) do
    %{app | state: :configured, configuration: configuration}
  end

  def apply(%Application{} = app, %Events.Application.Updated{configuration: configuration}) do
    %{app | state: :configured, configuration: configuration}
  end

  def apply(%Application{} = app, _) do
    app
  end
end
