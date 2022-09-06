defmodule Ecstatic.Family do
  use TypedStruct

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
          configuration: struct(Ecstatic.Family.Configuration, configuration),
          state: state
        }
        {:ok, family}
    end
    Ecstatic.Commanded.Repo.get_by(Ecstatic.Commanded.Projections.Family, application: application, name: name)
  end
  
  @spec list(Ecstatic.Application.t()) :: {:ok, list(Ecstatic.Family.t())} | {:error, atom()}
  def list(%Ecstatic.Application{name: application}) do
    Ecstatic.Commanded.Repo.all(Ecstatic.Commanded.Projections.Family, application: application)
    state = %Ecstatic.Family.State{
      status: :live
    }
    families = Ecstatic.Commanded.Repo.all(Ecstatic.Commanded.Projections.Family, application: application)
               |> Enum.map(fn c ->
                 %Ecstatic.Family{
                   application: c.application,
                   name: c.name,
                   configuration: struct(Ecstatic.Family.Configuration, c),
                   state: state
                 }
               end)
    {:ok, families}
  end
end
