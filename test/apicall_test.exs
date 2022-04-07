defmodule ApicallTest do
  use ExUnit.Case
  doctest Apicall

  test "greets the world" do
    assert Apicall.hello() == :world
  end
end
