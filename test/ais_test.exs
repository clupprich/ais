defmodule AisTest do
  use ExUnit.Case, async: true

  test "single sentence message" do
    {:ok, ais} = Ais.new
    assert Ais.get(ais) == []

    assert Ais.parse(ais, "!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C") ==
      {:ok,[talker: "!AI", formatter: "VDM", total: "1", current: "1", sequential: "", channel: "B",
       payload: "177KQJ5000G?tO`K>RA1wUbN0TKH", padding: "0", checksum: "5C"]}
    assert Ais.get(ais) == []
  end

  test "multi-sentence message" do
    {:ok, ais} = Ais.new
    assert Ais.get(ais) == []

    assert Ais.parse(ais, "!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E") ==
      {:incomplete, [talker: "!AI", formatter: "VDM", total: "2", current: "1", sequential: "3", channel: "B",
       payload: "55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53", padding: "0", checksum: "3E"]}
    assert Ais.parse(ais, "!AIVDM,2,2,3,B,1@0000000000000,2*55") ==
      {:ok,[talker: "!AI", formatter: "VDM", total: "2", current: "2", sequential: "3", channel: "B",
       payload: "55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E531@0000000000000", padding: "2",
       checksum: "55"] }
  end
end
