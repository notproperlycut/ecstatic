defmodule EcstaticTest do
  use ExUnit.Case
  doctest Ecstatic

  test "greets the world" do
    assert Ecstatic.hello() == :world
  end
end
