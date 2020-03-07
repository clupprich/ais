defmodule NMEATest do
  use ExUnit.Case, async: true
  doctest NMEA

  test "parse single-sentence" do
    assert NMEA.parse("!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C") ==
             {:ok, %{
               talker: "!AI",
               formatter: "VDM",
               total: "1",
               current: "1",
               sequential: "",
               channel: "B",
               payload: "177KQJ5000G?tO`K>RA1wUbN0TKH",
               padding: "0",
               checksum: "5C"
             }}
  end

  test "parse multi-sentence" do
    assert NMEA.parse(
             "!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E"
           ) ==
             {:ok, %{
               talker: "!AI",
               formatter: "VDM",
               total: "2",
               current: "1",
               sequential: "3",
               channel: "B",
               payload: "55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53",
               padding: "0",
               checksum: "3E"
             }}

    assert NMEA.parse("!AIVDM,2,2,3,B,1@0000000000000,2*55") ==
             {:ok, %{
               talker: "!AI",
               formatter: "VDM",
               total: "2",
               current: "2",
               sequential: "3",
               channel: "B",
               payload: "1@0000000000000",
               padding: "2",
               checksum: "55"
             }
            }
  end
end
