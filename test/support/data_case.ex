defmodule Ecstatic.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Commanded.Assertions.EventAssertions
    end
  end

  setup do
    {:ok, _} = Application.ensure_all_started(:ecstatic)

    on_exit(fn ->
      :ok = Application.stop(:ecstatic)

      Ecstatic.Storage.reset!()
    end)

    :ok
  end
end
