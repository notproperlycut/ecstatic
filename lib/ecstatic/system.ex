defmodule Ecstatic.System do
  use TypedStruct
  import Ecto.Query, only: [from: 2]

  typedstruct do
    field :application, String.t()
    field :name, String.t()
    field :configuration, Ecstatic.System.Configuration.t()
    field :state, Ecstatic.System.State.t()
  end

  @spec get(Ecstatic.Application.t(), String.t()) :: {:ok, Ecstatic.System.t()} | {:error, atom()}
  def get(%Ecstatic.Application{name: application}, name) do
    case Ecstatic.Commanded.Repo.get_by(Ecstatic.Commanded.Projections.System, application: application, name: name) do
      nil ->
        {:error, :not_found}
      configuration ->
        state = %Ecstatic.System.State{
          status: :live
        }
        system = %Ecstatic.System{
          application: configuration.application,
          name: configuration.name,
          configuration: Nestru.decode_from_map!(configuration, Ecstatic.System.Configuration),
          state: state
        }
        {:ok, system}
    end
  end
  
  @spec list(Ecstatic.Application.t()) :: {:ok, list(Ecstatic.System.t())} | {:error, atom()}
  def list(%Ecstatic.Application{name: application}) do
    state = %Ecstatic.System.State{
      status: :live
    }
    query = from(c in Ecstatic.Commanded.Projections.System, where: c.application == ^application)
    systems = Ecstatic.Commanded.Repo.all(query)
               |> Enum.map(fn c ->
                 %Ecstatic.System{
                   application: c.application,
                   name: c.name,
                   configuration: Nestru.decode_from_map!(c, Ecstatic.System.Configuration),
                   state: state
                 }
               end)
    {:ok, systems}
  end
end
