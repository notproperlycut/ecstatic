defmodule Ecstatic do
  alias Ecstatic.Commands

  def configure_application(%Commands.ConfigureApplication{} = application) do
    Ecstatic.Commanded.dispatch(application)
  end

  def remove_application(%Commands.RemoveApplication{} = application) do
    Ecstatic.Commanded.dispatch(application)
  end
end
