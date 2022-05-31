defmodule OauthImplementationTest do
  use ExUnit.Case
  doctest OauthImplementation

  test "greets the world" do
    assert OauthImplementation.hello() == :world
  end
end
