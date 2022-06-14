defmodule Ecstatic.Types.Names.Command do
  use Domo, skip_defaults: true
  alias Ecstatic.Types.Names

  defstruct [
    :system,
    :command
  ]

  @type t() :: %__MODULE__{
          system: Names.t(),
          command: Names.t()
        }
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end

defimpl String.Chars, for: Ecstatic.Types.Names.Command do
  def to_string(value), do: "#{value.system}.command.#{value.command}"
end
