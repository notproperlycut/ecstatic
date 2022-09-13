defmodule Ecstatic.Event do
  use TypedStruct
  import Ecto.Query, only: [from: 2]

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
          configuration: Nestru.decode_from_map!(configuration, Ecstatic.Event.Configuration),
          state: state
        }
        {:ok, event}
    end
  end
  
  @spec list(Ecstatic.Application.t()) :: {:ok, list(Ecstatic.Event.t())} | {:error, atom()}
  def list(%Ecstatic.Application{name: application}) do
    state = %Ecstatic.Event.State{
      status: :live
    }
    query = from(c in Ecstatic.Commanded.Projections.Event, where: c.application == ^application)
    events = Ecstatic.Commanded.Repo.all(query)
               |> Enum.map(fn c ->
                 %Ecstatic.Event{
                   application: c.application,
                   name: c.name,
                   configuration: Nestru.decode_from_map!(c, Ecstatic.Event.Configuration),
                   state: state
                 }
               end)
    {:ok, events}
  end
end
