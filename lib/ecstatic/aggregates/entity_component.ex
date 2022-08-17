defmodule Ecstatic.Aggregates.EntityComponent do
  use TypedStruct

  alias Ecstatic.Aggregates.EntityComponent
  alias Ecstatic.Commands
  alias Ecstatic.Events

  typedstruct do
    field :state, any(), default: nil
  end

  #
  def execute(%EntityComponent{} = _entity_component, %Commands.ExecuteCommand{} = command) do
    %Ecstatic.Events.CommandStarted{id: command.entity_component_id}
  end

  #
  def apply(%EntityComponent{}, %Events.CommandStarted{}) do
    %EntityComponent{state: :started}
  end
end
