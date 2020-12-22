defmodule Ecstatic.Engines.Aggregates.Engine do
  defstruct [:engine_id, :state]

  alias Ecstatic.Engines.Aggregates.Engine
  alias Ecstatic.Engines.Commands.{
    CreateEngine,
    DestroyEngine
  }
  alias Ecstatic.Engines.Events.{
    EngineCreated,
    EngineDestroyed
  }

  # Public command API

  def execute(%Engine{state: :destroyed}, _) do
    {:error, :engine_destroyed}
  end

  def execute(%Engine{engine_id: nil}, %CreateEngine{engine_id: engine_id, api_secret: api_secret}) do
    %EngineCreated{engine_id: engine_id, api_secret: api_secret}
  end

  def execute(%Engine{}, %CreateEngine{}) do
    {:error, :engine_already_created}
  end

  def execute(%Engine{engine_id: nil}, _) do
    {:error, :engine_not_found}
  end

  def execute(%Engine{}, %DestroyEngine{engine_id: engine_id}) do
    %EngineDestroyed{engine_id: engine_id}
  end

  # State mutators

  def apply(%Engine{} = engine, %EngineCreated{engine_id: engine_id}) do
    %Engine{engine |
      engine_id: engine_id,
      state: :created
    }
  end

  def apply(%Engine{} = engine, %EngineDestroyed{}) do
    %Engine{engine |
      state: :destroyed
    }
  end
end
