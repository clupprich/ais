defmodule NMEAAishubSampleTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  # Sample file comes from https://www.aishub.net/ais-dispatcher

  test "parse sample nmea file" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    File.read!("test/nmea-sample.gz")
    |> :zlib.gunzip()
    |> String.split()
    |> Enum.each(fn x ->
      # IO.inspect(x)
      {result, _} = AIS.parse(ais, x)
      assert result in [:ok, :incomplete]
    end)
  end
end
