defmodule AISTest do
  use ExUnit.Case, async: true

  test "single sentence message" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C") ==
             {:ok,
              %{
                talker: "!AI",
                formatter: "VDM",
                total: "1",
                current: "1",
                sequential: "",
                channel: "B",
                payload: "177KQJ5000G?tO`K>RA1wUbN0TKH",
                padding: "0",
                checksum: "5C",
                cog: 510,
                communication_state: 149208,
                latitude: 28549700,
                longitude: 195027956,
                message_id: 1,
                navigational_status: 5,
                position_acucuracy: 0,
                raim_flag: 0,
                rate_of_turn: 0,
                repeat_indicator: 0,
                sog: 0,
                spare: 0,
                special_manoeuvre_indicator: 0,
                time_stamp: 15,
                true_heading: 181,
                user_id: 477553000
              }}

    assert AIS.get(ais) == []
  end

  test "multi-sentence message" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(
             ais,
             "!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E"
           ) ==
             {:incomplete,
              %{
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

    assert AIS.parse(ais, "!AIVDM,2,2,3,B,1@0000000000000,2*55") ==
             {:ok,
              %{
                talker: "!AI",
                formatter: "VDM",
                total: "2",
                current: "2",
                sequential: "3",
                channel: "B",
                message_id: 5,
                ais_version_indicator: 0,
                imo_number: 6_710_932,
                repeat_indicator: 0,
                user_id: 369_190_000,
                call_sign: "WDA9674",
                type_of_ship_and_cargo_type: 99,
                type_of_electronic_position_fixing_devise: 1,
                eta: 70144,
                maximum_present_static_draught: 60,
                destination: "SEATTLE",
                name: "MT.MITCHELL",
                dimension_a: 90,
                dimension_b: 90,
                dimension_c: 10,
                dimension_d: 10,
                dte: 0,
                spare: 0,
                payload: "55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E531@0000000000000",
                padding: "2",
                checksum: "55"
              }}
  end
end
