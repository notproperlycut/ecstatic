defmodule Ecstatic.Types.Names.Event do
  use Domo, skip_defaults: true
  alias Ecstatic.Types.Names

  defstruct [
    :system,
    :event
  ]

  @type t() :: %__MODULE__{
          system: Names.t(),
          event: Names.t()
        }
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end

defimpl String.Chars, for: Ecstatic.Types.Names.Event do
  def to_string(value), do: "#{value.system}.event.#{value.event}"
end
