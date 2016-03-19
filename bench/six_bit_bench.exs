defmodule SixBitBench do
  use Benchfella

  @ais "14eG;o@034o8sd<L9i:a;WF>062D"

  bench "encode" do
    SixBit.encode(@ais)
  end
end
