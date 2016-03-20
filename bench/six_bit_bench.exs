defmodule SixBitBench do
  use Benchfella

  @ais "14eG;o@034o8sd<L9i:a;WF>062D"

  bench "decode" do
    SixBit.decode(@ais)
  end
end
