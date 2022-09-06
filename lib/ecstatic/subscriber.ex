defmodule Ecstatic.Subscriber do
  use TypedStruct

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
          configuration: struct(Ecstatic.Subscriber.Configuration, configuration),
          state: state
        }
        {:ok, subscriber}
    end
    Ecstatic.Commanded.Repo.get_by(Ecstatic.Commanded.Projections.Subscriber, application: application, name: name)
  end
  
  @spec list(Ecstatic.Application.t()) :: {:ok, list(Ecstatic.Subscriber.t())} | {:error, atom()}
  def list(%Ecstatic.Application{name: application}) do
    Ecstatic.Commanded.Repo.all(Ecstatic.Commanded.Projections.Subscriber, application: application)
    state = %Ecstatic.Subscriber.State{
      status: :live
    }
    subscribers = Ecstatic.Commanded.Repo.all(Ecstatic.Commanded.Projections.Subscriber, application: application)
               |> Enum.map(fn c ->
                 %Ecstatic.Subscriber{
                   application: c.application,
                   name: c.name,
                   configuration: struct(Ecstatic.Subscriber.Configuration, c),
                   state: state
                 }
               end)
    {:ok, subscribers}
  end
end
