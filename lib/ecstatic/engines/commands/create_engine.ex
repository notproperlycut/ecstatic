defmodule Ecstatic.Engines.Commands.CreateEngine do
  defstruct [:engine_id, :api_secret]

  use ExConstructor
  use Vex.Struct

  validates(:engine_id, presence: true, uuid: true)
  validates(:api_secret, presence: true, length: [min: 4])
end
