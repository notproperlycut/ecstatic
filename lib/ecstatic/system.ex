defmodule Ecstatic.System do
  use TypedStruct

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
          configuration: struct(Ecstatic.System.Configuration, configuration),
          state: state
        }
        {:ok, system}
    end
    Ecstatic.Commanded.Repo.get_by(Ecstatic.Commanded.Projections.System, application: application, name: name)
  end
  
  @spec list(Ecstatic.Application.t()) :: {:ok, list(Ecstatic.System.t())} | {:error, atom()}
  def list(%Ecstatic.Application{name: application}) do
    Ecstatic.Commanded.Repo.all(Ecstatic.Commanded.Projections.System, application: application)
    state = %Ecstatic.System.State{
      status: :live
    }
    systems = Ecstatic.Commanded.Repo.all(Ecstatic.Commanded.Projections.System, application: application)
               |> Enum.map(fn c ->
                 %Ecstatic.System{
                   application: c.application,
                   name: c.name,
                   configuration: struct(Ecstatic.System.Configuration, c),
                   state: state
                 }
               end)
    {:ok, systems}
  end
end
