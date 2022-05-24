defmodule Ecstatic.Aggregates.Application do
  defstruct [
    id: nil,
  ]

  alias Ecstatic.Aggregates.Application
  alias Ecstatic.Commands
  alias Ecstatic.Events

  def execute(%Application{id: :removed}, _) do
    {:error, :removed_application}
  end

  def execute(%Application{id: nil}, %Commands.ConfigureApplication{} = command) do
    %Commands.ConfigureApplication{id: id} = command
    %Events.ApplicationConfigured{id: id}
  end

  def execute(%Application{id: nil}, _) do
    {:error, :no_such_application}
  end

  def execute(%Application{}, %Commands.RemoveApplication{} = command) do
    %Commands.RemoveApplication{id: id} = command
    %Events.ApplicationRemoved{id: id}
  end


  def apply(%Application{}, %Events.ApplicationConfigured{} = event) do
    %Events.ApplicationConfigured{id: id} = event

    %Application{id: id}
  end

  def apply(%Application{}, %Events.ApplicationRemoved{}) do
    %Application{id: :removed}
  end
end
