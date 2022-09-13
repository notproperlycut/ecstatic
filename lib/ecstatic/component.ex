defmodule Ecstatic.Component do
  use TypedStruct
  import Ecto.Query, only: [from: 2]

  typedstruct do
    field :application, String.t()
    field :name, String.t()
    field :configuration, Ecstatic.Component.Configuration.t()
    field :state, Ecstatic.Component.State.t()
  end

  @spec get(Ecstatic.Application.t(), String.t()) :: {:ok, Ecstatic.Component.t()} | {:error, atom()}
  def get(%Ecstatic.Application{name: application}, name) do
    case Ecstatic.Commanded.Repo.get_by(Ecstatic.Commanded.Projections.Component, application: application, name: name) do
      nil ->
        {:error, :not_found}
      configuration ->
        state = %Ecstatic.Component.State{
          status: :live
        }
        component = %Ecstatic.Component{
          application: configuration.application,
          name: configuration.name,
          configuration: Nestru.decode_from_map!(configuration, Ecstatic.Component.Configuration),
          state: state
        }
        {:ok, component}
    end
  end
  
  @spec list(Ecstatic.Application.t()) :: {:ok, list(Ecstatic.Component.t())} | {:error, atom()}
  def list(%Ecstatic.Application{name: application}) do
    state = %Ecstatic.Component.State{
      status: :live
    }
    query = from(c in Ecstatic.Commanded.Projections.Component, where: c.application == ^application)
    components = Ecstatic.Commanded.Repo.all(query)
               |> Enum.map(fn c ->
                 %Ecstatic.Component{
                   application: c.application,
                   name: c.name,
                   configuration: Nestru.decode_from_map!(c, Ecstatic.Component.Configuration),
                   state: state
                 }
               end)
    {:ok, components}
  end
end
