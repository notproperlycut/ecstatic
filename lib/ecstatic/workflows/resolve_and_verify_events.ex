defmodule Ecstatic.Workflows.ResolveAndVerifyEvents do
  # TODO: what event types are allowed to be returned from this invocation?
  def resolve(%Ecstatic.Types.CommandInvocation{} = command_invocation, events) do
    events = events |> Enum.map(fn e ->
      {:ok, resolved_name} = Ecstatic.Types.Name.long(command_invocation.command, :event, e.name)
      %{e | name: resolved_name}
    end)

    {:ok, events}
  end
end
