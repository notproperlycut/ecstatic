defmodule Ecstatic.Component do
  use TypedStruct

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
          configuration: struct(Ecstatic.Component.Configuration, configuration),
          state: state
        }
        {:ok, component}
    end
    Ecstatic.Commanded.Repo.get_by(Ecstatic.Commanded.Projections.Component, application: application, name: name)
  end
  
  @spec list(Ecstatic.Application.t()) :: {:ok, list(Ecstatic.Component.t())} | {:error, atom()}
  def list(%Ecstatic.Application{name: application}) do
    Ecstatic.Commanded.Repo.all(Ecstatic.Commanded.Projections.Component, application: application)
    state = %Ecstatic.Component.State{
      status: :live
    }
    components = Ecstatic.Commanded.Repo.all(Ecstatic.Commanded.Projections.Component, application: application)
               |> Enum.map(fn c ->
                 %Ecstatic.Component{
                   application: c.application,
                   name: c.name,
                   configuration: struct(Ecstatic.Component.Configuration, c),
                   state: state
                 }
               end)
    {:ok, components}
  end
end
