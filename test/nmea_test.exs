defmodule NmeaTest do
  use ExUnit.Case, async: true
  doctest Nmea

  test "parse single-sentence" do
    assert Nmea.parse("!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C") ==
      [talker: "!AI", formatter: "VDM", current: "1", total: "1", sequential: "", channel: "B",
       payload: "177KQJ5000G?tO`K>RA1wUbN0TKH", padding: "0", checksum: "5C"]
  end

  test "parse multi-sentence" do
    assert Nmea.parse("!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E") ==
      [talker: "!AI", formatter: "VDM", current: "2", total: "1", sequential: "3", channel: "B",
       payload: "55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53", padding: "0", checksum: "3E"]

    assert Nmea.parse("!AIVDM,2,2,3,B,1@0000000000000,2*55") ==
      [talker: "!AI", formatter: "VDM", current: "2", total: "2", sequential: "3", channel: "B",
       payload: "1@0000000000000", padding: "2", checksum: "55"]
  end
end
