defmodule Ecstatic.Engines.Commands.DestroyEngine do
  defstruct [:engine_id]

  use ExConstructor
  use Vex.Struct

  validates(:engine_id, uuid: true)
end
