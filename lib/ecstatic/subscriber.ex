defmodule Ecstatic.Subscriber do
  use TypedStruct
  import Ecto.Query, only: [from: 2]

  typedstruct do
    field :application, String.t()
    field :name, String.t()
    field :configuration, Ecstatic.Subscriber.Configuration.t()
    field :state, Ecstatic.Subscriber.State.t()
  end

  @spec get(Ecstatic.Application.t(), String.t()) :: {:ok, Ecstatic.Subscriber.t()} | {:error, atom()}
  def get(%Ecstatic.Application{name: application}, name) do
    case Ecstatic.Commanded.Repo.get_by(Ecstatic.Commanded.Projections.Subscriber, application: application, name: name) do
      nil ->
        {:error, :not_found}
      configuration ->
        state = %Ecstatic.Subscriber.State{
          status: :live
        }
        subscriber = %Ecstatic.Subscriber{
          application: configuration.application,
          name: configuration.name,
          configuration: Nestru.decode_from_map!(configuration, Ecstatic.Subscriber.Configuration),
          state: state
        }
        {:ok, subscriber}
    end
  end
  
  @spec list(Ecstatic.Application.t()) :: {:ok, list(Ecstatic.Subscriber.t())} | {:error, atom()}
  def list(%Ecstatic.Application{name: application}) do
    state = %Ecstatic.Subscriber.State{
      status: :live
    }
    query = from(c in Ecstatic.Commanded.Projections.Subscriber, where: c.application == ^application)
    subscribers = Ecstatic.Commanded.Repo.all(query)
               |> Enum.map(fn c ->
                 %Ecstatic.Subscriber{
                   application: c.application,
                   name: c.name,
                   configuration: Nestru.decode_from_map!(c, Ecstatic.Subscriber.Configuration),
                   state: state
                 }
               end)
    {:ok, subscribers}
  end
end
