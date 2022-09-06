defmodule Ecstatic.Commanded.Aggregates.Application do
  use TypedStruct

  typedstruct do
    field :state, any(), default: nil
  end

  alias Ecstatic.Commanded.Aggregates.Application
  alias Ecstatic.Commanded.Commands
  alias Ecstatic.Commanded.Events

  #
  def execute(%Application{state: :removed}, _) do
    {:error, :removed_application}
  end

  def execute(%Application{state: nil}, %Commands.ConfigureApplication{} = command) do
    Ecstatic.Commanded.Aggregates.Application.State.configure(%Application.State{}, command)
  end

  def execute(%Application{} = app, %Commands.ConfigureApplication{} = command) do
    Ecstatic.Commanded.Aggregates.Application.State.configure(app.state, command)
  end

  def execute(%Application{state: nil}, _) do
    {:error, :no_such_application}
  end

  def execute(%Application{} = app, %Commands.RemoveApplication{}) do
    Ecstatic.Commanded.Aggregates.Application.State.remove(app.state)
  end

  #
  def apply(%Application{state: :removed}, _) do
    %Application{state: :removed}
  end

  def apply(%Application{}, %Events.ApplicationRemoved{}) do
    %Application{state: :removed}
  end

  def apply(%Application{} = app, event) do
    %{app | state: Application.State.update(app.state || %Application.State{}, event)}
  end
end
