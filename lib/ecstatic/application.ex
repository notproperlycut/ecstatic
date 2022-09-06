defmodule Ecstatic.Application do
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
    field :state, atom(), enforce: true
  end

  @spec get(String.t()) :: {:ok, Ecstatic.Application.t()} | {:error, atom()}
  def get(name) do
    application = case Ecstatic.Commanded.Repo.get_by(Ecstatic.Commanded.Projections.Application, name: name) do
      nil ->
        %Ecstatic.Application{
          name: name,
          state: :unconfigured
        }
      %{name: name} ->
        %Ecstatic.Application{
          name: name,
          state: :configured
        }
    end
    {:ok, application}
  end

  @spec list() :: {:ok, list(Ecstatic.Application.t())} | {:error, atom()}
  def list() do
    applications = Ecstatic.Commanded.Repo.all(Ecstatic.Commanded.Projections.Application) |> Enum.map(fn a ->
      %Ecstatic.Application{
        name: a.name,
        state: :configured
      }
    end)
    {:ok, applications}
  end

  @spec unpack_configuration(map()) :: {:ok, Ecstatic.Application.Configuration.t()} | {:error, atom()}
  def unpack_configuration(_nested_configuration) do
    configuration = %Ecstatic.Application.Configuration{
    }
    {:ok, configuration}
  end

  @spec configure(Ecstatic.Application.t(), Ecstatic.Application.Configuration.t()) :: :ok | {:error, atom()}
  def configure(%__MODULE__{name: name}, %Ecstatic.Application.Configuration{} = configuration) do
    command = %Ecstatic.Commanded.Commands.ConfigureApplication{
      name: name,
      configuration: configuration
    }
    Ecstatic.Commanded.Application.dispatch(command, consistency: :strong)
  end

  @spec remove(Ecstatic.Application.t()) :: :ok | {:error, atom()}
  def remove(%__MODULE__{name: name}) do
    command = %Ecstatic.Commanded.Commands.RemoveApplication{
      name: name
    }
    Ecstatic.Commanded.Application.dispatch(command, consistency: :strong)
  end

end
