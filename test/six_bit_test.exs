defmodule SixBitTest do
  use ExUnit.Case
  doctest SixBit

  test "encode payload" do
    assert SixBit.encode("14eG;o@034o8sd<L9i:a;WF>062D") == <<4, 75, 87, 47, 116, 0, 12, 77, 200, 238, 195, 28, 39, 18, 169, 46, 117, 142, 0, 96, 148>>
  end
end
