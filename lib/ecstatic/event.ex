defmodule Ecstatic.Event do
  use TypedStruct

  typedstruct do
    field :application, String.t()
    field :name, String.t()
    field :configuration, Ecstatic.Event.Configuration.t()
    field :state, Ecstatic.Event.State.t()
  end

  @spec get(Ecstatic.Application.t(), String.t()) :: {:ok, Ecstatic.Event.t()} | {:error, atom()}
  def get(%Ecstatic.Application{name: application}, name) do
    case Ecstatic.Commanded.Repo.get_by(Ecstatic.Commanded.Projections.Event, application: application, name: name) do
      nil ->
        {:error, :not_found}
      configuration ->
        state = %Ecstatic.Event.State{
          status: :live
        }
        event = %Ecstatic.Event{
          application: configuration.application,
          name: configuration.name,
          configuration: struct(Ecstatic.Event.Configuration, configuration),
          state: state
        }
        {:ok, event}
    end
    Ecstatic.Commanded.Repo.get_by(Ecstatic.Commanded.Projections.Event, application: application, name: name)
  end
  
  @spec list(Ecstatic.Application.t()) :: {:ok, list(Ecstatic.Event.t())} | {:error, atom()}
  def list(%Ecstatic.Application{name: application}) do
    Ecstatic.Commanded.Repo.all(Ecstatic.Commanded.Projections.Event, application: application)
    state = %Ecstatic.Event.State{
      status: :live
    }
    events = Ecstatic.Commanded.Repo.all(Ecstatic.Commanded.Projections.Event, application: application)
               |> Enum.map(fn c ->
                 %Ecstatic.Event{
                   application: c.application,
                   name: c.name,
                   configuration: struct(Ecstatic.Event.Configuration, c),
                   state: state
                 }
               end)
    {:ok, events}
  end
end
