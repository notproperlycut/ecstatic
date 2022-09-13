defmodule Ecstatic.Family do
  use TypedStruct
  import Ecto.Query, only: [from: 2]

  typedstruct do
    field :application, String.t()
    field :name, String.t()
    field :configuration, Ecstatic.Family.Configuration.t()
    field :state, Ecstatic.Family.State.t()
  end

  @spec get(Ecstatic.Application.t(), String.t()) :: {:ok, Ecstatic.Family.t()} | {:error, atom()}
  def get(%Ecstatic.Application{name: application}, name) do
    case Ecstatic.Commanded.Repo.get_by(Ecstatic.Commanded.Projections.Family, application: application, name: name) do
      nil ->
        {:error, :not_found}
      configuration ->
        state = %Ecstatic.Family.State{
          status: :live
        }
        family = %Ecstatic.Family{
          application: configuration.application,
          name: configuration.name,
          configuration: Nestru.decode_from_map!(configuration, Ecstatic.Family.Configuration),
          state: state
        }
        {:ok, family}
    end
  end
  
  @spec list(Ecstatic.Application.t()) :: {:ok, list(Ecstatic.Family.t())} | {:error, atom()}
  def list(%Ecstatic.Application{name: application}) do
    state = %Ecstatic.Family.State{
      status: :live
    }
    query = from(c in Ecstatic.Commanded.Projections.Family, where: c.application == ^application)
    families = Ecstatic.Commanded.Repo.all(query)
               |> Enum.map(fn c ->
                 %Ecstatic.Family{
                   application: c.application,
                   name: c.name,
                   configuration: Nestru.decode_from_map!(c, Ecstatic.Family.Configuration),
                   state: state
                 }
               end)
    {:ok, families}
  end
end
