defmodule Ecstatic.Command do
  use TypedStruct

  typedstruct do
    field :application, String.t()
    field :name, String.t()
    field :configuration, Ecstatic.Command.Configuration.t()
    field :state, Ecstatic.Command.State.t()
  end

  @spec get(Ecstatic.Application.t(), String.t()) :: {:ok, Ecstatic.Command.t()} | {:error, atom()}
  def get(%Ecstatic.Application{name: application}, name) do
    case Ecstatic.Commanded.Repo.get_by(Ecstatic.Commanded.Projections.Command, application: application, name: name) do
      nil ->
        {:error, :not_found}
      configuration ->
        state = %Ecstatic.Command.State{
          status: :live
        }
        command = %Ecstatic.Command{
          application: configuration.application,
          name: configuration.name,
          configuration: struct(Ecstatic.Command.Configuration, configuration),
          state: state
        }
        {:ok, command}
    end
  end

  @spec list(Ecstatic.Application.t()) :: {:ok, list(Ecstatic.Command.t())} | {:error, atom()}
  def list(%Ecstatic.Application{name: application}) do
    state = %Ecstatic.Command.State{
      status: :live
    }
    commands = Ecstatic.Commanded.Repo.all(Ecstatic.Commanded.Projections.Command, application: application)
               |> Enum.map(fn c ->
                 %Ecstatic.Command{
                   application: c.application,
                   name: c.name,
                   configuration: struct(Ecstatic.Command.Configuration, c),
                   state: state
                 }
               end)
    {:ok, commands}
  end
end
