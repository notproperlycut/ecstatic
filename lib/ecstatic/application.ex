defmodule Ecstatic.Application do
  use TypedStruct

  defdelegate unpack(configuration), to: Ecstatic.Application.Configuration

  typedstruct do
    field :name, String.t(), enforce: true
    field :state, atom(), enforce: true
  end

  @spec get(String.t()) :: {:ok, Ecstatic.Application.t()}
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

  @spec configure(Ecstatic.Application.t(), Ecstatic.Application.Configuration.t()) :: :ok | {:error, atom()}
  def configure(%__MODULE__{name: name}, %Ecstatic.Application.Configuration{} = configuration) do
    with {:ok, configuration} <- Ecstatic.Application.Configuration.ensure_type(configuration) do
      command = %Ecstatic.Commanded.Commands.Application.Configure{
        name: name,
        configuration: configuration
      }
      Ecstatic.Commanded.Application.dispatch(command, consistency: :strong)
    end
  end

  @spec remove(Ecstatic.Application.t()) :: :ok | {:error, atom()}
  def remove(%__MODULE__{name: name}) do
    command = %Ecstatic.Commanded.Commands.Application.Remove{
      name: name
    }
    Ecstatic.Commanded.Application.dispatch(command, consistency: :strong)
  end
end
