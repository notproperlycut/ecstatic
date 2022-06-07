defmodule Ecstatic.Aggregates.Application do
  defstruct state: nil

  alias Ecstatic.Aggregates.Application
  alias Ecstatic.Commands
  alias Ecstatic.Events

  #
  def execute(%Application{state: :removed}, _) do
    {:error, :removed_application}
  end

  def execute(%Application{state: nil}, %Commands.ConfigureApplication{} = command) do
    Ecstatic.Aggregates.Application.State.configure(%Application.State{}, command)
  end

  def execute(%Application{} = app, %Commands.ConfigureApplication{} = command) do
    Ecstatic.Aggregates.Application.State.configure(app.state, command)
  end

  def execute(%Application{state: nil}, _) do
    {:error, :no_such_application}
  end

  def execute(%Application{} = app, %Commands.RemoveApplication{}) do
    Ecstatic.Aggregates.Application.State.remove(app.state)
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
