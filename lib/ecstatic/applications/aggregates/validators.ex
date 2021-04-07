defmodule Ecstatic.Applications.Aggregates.Validators do
  def prepend_message(:ok, _prepend) do
    :ok
  end

  def prepend_message({:error, messages}, prepend) when is_list(messages) do
    {:error, Enum.map(messages, & prepend <> &1)}
  end

  def prepend_message({:error, message}, prepend) when is_binary(message) do
    message = prepend <> message
    {:error, message}
  end

  def any_ok?(errors) when is_list(errors) do
    Enum.any?(errors, & &1 == :ok)
  end

  def collate_errors(:ok) do
    :ok
  end

  def collate_errors({:error, errors}) do
    {:error, List.flatten(errors)}
  end

  def collate_errors(errors) when is_list(errors) do
    collated = errors
    |> List.flatten()
    |> Enum.reject(& &1 == :ok)
    |> Enum.map(fn {:error, error} -> error end)
    |> List.flatten()

    if Enum.empty?(collated) do
      :ok
    else
      {:error, collated}
    end
  end
end
