defmodule LichenTest do
  use ExUnit.Case
  doctest Lichen

  test "greets the world" do
    assert Lichen.hello() == :world
  end
end
