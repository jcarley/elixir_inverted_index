defmodule IndexTest do
  use ExUnit.Case
  doctest Index

  test "it is empty" do

    keys = [1, 2, 3, 4, 5, 6, 7]
    f = fn([head | tail]) ->
      IO.inspect(head)
      IO.inspect(tail)
    end
    f.(keys)

  end

end
