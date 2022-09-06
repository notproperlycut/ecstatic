defmodule Ecstatic.Commanded.Workflows.ResolveAndVerifyEvents do
  # TODO: what event types are allowed to be returned from this invocation?
  def resolve(%Ecstatic.Commanded.Types.CommandInvocation{} = command_invocation, events) do
    events = events |> Enum.map(fn e ->
      {:ok, resolved_name} = Ecstatic.Commanded.Types.Name.long(command_invocation.command, :event, e.name)
      %{e | name: resolved_name}
    end)

    {:ok, events}
  end
end
