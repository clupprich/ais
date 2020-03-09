defmodule AisMessageTypesTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  test "message type 1" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,B,13IbQQ000100lq`LD7J6Vi<n88AM,0*52") ==
             {:ok,
              %{
                channel: "B",
                checksum: "52",
                cog: 169.1,
                communication_state: 33885,
                current: "1",
                formatter: "VDM",
                latitude: 49.48284,
                longitude: 0.18056666666666665,
                message_id: 1,
                navigational_status: 0,
                padding: "0",
                payload: "13IbQQ000100lq`LD7J6Vi<n88AM",
                position_accuracy: 0,
                raim_flag: 0,
                rate_of_turn: 0,
                repeat_indicator: 0,
                sequential: "",
                sog: 0.1,
                spare: 2,
                special_maneuvre_indicator: 0,
                talker: "!AI",
                time_stamp: 27,
                total: "1",
                true_heading: 38,
                user_id: 228_237_700
              }}
  end

  test "message type 2" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,23aDrf0P12PBCNpMKVQ4OOvfR0S0,0*3E") ==
             {:ok,
              %{
                channel: "A",
                checksum: "3E",
                cog: 114.9,
                communication_state: 2240,
                current: "1",
                formatter: "VDM",
                latitude: 51.434886666666664,
                longitude: 3.99866,
                message_id: 2,
                navigational_status: 0,
                padding: "0",
                payload: "23aDrf0P12PBCNpMKVQ4OOvfR0S0",
                position_accuracy: 1,
                raim_flag: 1,
                rate_of_turn: -128,
                repeat_indicator: 0,
                sequential: "",
                sog: 6.6,
                spare: 0,
                special_maneuvre_indicator: 1,
                talker: "!AI",
                time_stamp: 23,
                total: "1",
                true_heading: 511,
                user_id: 244_660_920
              }}
  end

  test "message type 3" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,B,39NSDjP02201T0HLBJDBv2GD02s1,0*14") ==
             {:ok,
              %{
                channel: "B",
                checksum: "14",
                cog: 76.0,
                communication_state: 11969,
                current: "1",
                formatter: "VDM",
                latitude: 49.436295,
                longitude: 0.34135333333333334,
                message_id: 3,
                navigational_status: 0,
                padding: "0",
                payload: "39NSDjP02201T0HLBJDBv2GD02s1",
                position_accuracy: 0,
                raim_flag: 0,
                rate_of_turn: 0,
                repeat_indicator: 0,
                sequential: "",
                sog: 13.0,
                spare: 0,
                special_maneuvre_indicator: 0,
                talker: "!AI",
                time_stamp: 42,
                total: "1",
                true_heading: 75,
                user_id: 636_015_818
              }}
  end

  test "message type 4" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,402;bFQv@kkLc00Dl4LE52100@J6,0*58") ==
             {:ok,
              %{
                channel: "A",
                checksum: "58",
                communication_state: 67206,
                current: "1",
                formatter: "VDM",
                latitude: 49.50913333333333,
                longitude: 0.07104333333333333,
                message_id: 4,
                padding: "0",
                payload: "402;bFQv@kkLc00Dl4LE52100@J6",
                position_accuracy: 0,
                raim_flag: 0,
                repeat_indicator: 0,
                sequential: "",
                spare: 0,
                talker: "!AI",
                total: "1",
                transmission_control_for_long_range_broadcast_message: 0,
                type_of_electronic_position_fixing_device: 1,
                user_id: 2_288_218,
                utc_day: 7,
                utc_hour: 19,
                utc_minute: 28,
                utc_month: 3,
                utc_second: 43,
                utc_year: 2020
              }}
  end

  test "message type 5" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(
             ais,
             "!AIVDM,2,1,9,B,53qH`N0286j=<p8b220ti`62222222222222221?9p;554oF0;B3k51CPEH8,0*58"
           ) ==
             {:error,
              {:incomplete,
               %{
                 channel: "B",
                 checksum: "58",
                 current: "1",
                 formatter: "VDM",
                 padding: "0",
                 payload: "53qH`N0286j=<p8b220ti`62222222222222221?9p;554oF0;B3k51CPEH8",
                 sequential: "9",
                 talker: "!AI",
                 total: "2"
               }}}

    assert AIS.parse(
             ais,
             "!AIVDM,2,2,9,B,88888888880,2*2E"
           ) ==
             {:ok,
              %{
                ais_version_indicator: 0,
                call_sign: "SNBJ   ",
                channel: "B",
                checksum: "2E",
                current: "2",
                destination: "HOLTENAU            ",
                dimension_a: 79,
                dimension_b: 11,
                dimension_c: 5,
                dimension_d: 5,
                dte: 0,
                eta: %{day: 14, hour: 22, minute: 0, month: 3},
                formatter: "VDM",
                imo_number: 8_919_843,
                maximum_present_static_draught: 4.5,
                message_id: 5,
                name: "OLZA                ",
                padding: "2",
                payload:
                  "53qH`N0286j=<p8b220ti`62222222222222221?9p;554oF0;B3k51CPEH888888888880",
                repeat_indicator: 0,
                sequential: "9",
                spare: 0,
                talker: "!AI",
                total: "2",
                type_of_electronic_position_fixing_device: 1,
                type_of_ship_and_cargo_type: 79,
                user_id: 261_499_000
              }}
  end

  test "message type 6" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,6>jCKIkfJjOt>db;q700@20,2*16") ==
             {:ok,
              %{
                channel: "A",
                checksum: "16",
                current: "1",
                destination_id: 999_999_999,
                formatter: "VDM",
                message_id: 6,
                padding: "2",
                payload: "6>jCKIkfJjOt>db;q700@20",
                repeat_indicator: 0,
                retransmit_flag: 0,
                sequence_number: 0,
                sequential: "",
                source_id: 992_271_207,
                spare: 0,
                talker: "!AI",
                total: "1",
                application_data: <<139, 228, 112, 0, 64, 32, 0::size(2)>>,
                application_identifier: 15050
              }}
  end

  test "message type 7" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,777QkG00RW38,0*62") ==
             {:ok,
              %{
                channel: "A",
                checksum: "62",
                current: "1",
                formatter: "VDM",
                message_id: 7,
                padding: "0",
                payload: "777QkG00RW38",
                repeat_indicator: 0,
                sequential: "",
                source_id: 477_655_900,
                spare: 0,
                talker: "!AI",
                total: "1",
                id_1: 2_268_210,
                seq_1: 0
              }}
  end

  test "message type 8" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,83HT5APj2P00000001BQJ@2E0000,0*72") ==
             {:ok,
              %{
                channel: "A",
                checksum: "72",
                current: "1",
                formatter: "VDM",
                message_id: 8,
                padding: "0",
                payload: "83HT5APj2P00000001BQJ@2E0000",
                repeat_indicator: 0,
                sequential: "",
                source_id: 227_083_590,
                spare: 0,
                talker: "!AI",
                total: "1",
                application_identifier: 12810,
                data: <<0, 0, 0, 0, 0, 0, 20, 161, 105, 0, 149, 0, 0, 0>>
              }}
  end

  test "message type 9" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,B,91b55vRAirOn<94M097lV@@20<6=,0*5D") ==
             {:ok,
              %{
                altitude: 583,
                altitude_sensor: 0,
                assigned_mode_flag: 0,
                channel: "B",
                checksum: "5D",
                cog: 117.7,
                communication_state: 49549,
                communication_state_selector_flag: 0,
                current: "1",
                dte: 1,
                formatter: "VDM",
                latitude: 50.685065,
                longitude: -2.14309,
                message_id: 9,
                padding: "0",
                payload: "91b55vRAirOn<94M097lV@@20<6=",
                position_accuracy: 0,
                raim_flag: 0,
                repeat_indicator: 0,
                sequential: "",
                sog: 122,
                spare1: 0,
                spare2: 0,
                talker: "!AI",
                time_stamp: 1,
                total: "1",
                user_id: 111_232_506
              }}
  end

  test "message type 10" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,:81:Jf1D02J0,0*0E") ==
             {:ok,
              %{
                channel: "A",
                checksum: "0E",
                current: "1",
                destination_id: 352_324_000,
                formatter: "VDM",
                message_id: 10,
                padding: "0",
                payload: ":81:Jf1D02J0",
                repeat_indicator: 0,
                sequential: "",
                source_id: 538_090_168,
                spare1: 0,
                spare2: 0,
                talker: "!AI",
                total: "1"
              }}
  end

  test "message type 11" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,;028j>iuho;PLO0ARF@EEmG008AG,0*31") ==
             {:ok,
              %{
                channel: "A",
                checksum: "31",
                communication_state: 33879,
                current: "1",
                formatter: "VDM",
                latitude: 28.544781666666665,
                longitude: -13.921155,
                message_id: 11,
                padding: "0",
                payload: ";028j>iuho;PLO0ARF@EEmG008AG",
                position_accuracy: 0,
                raim_flag: 0,
                repeat_indicator: 0,
                sequential: "",
                spare: 0,
                talker: "!AI",
                total: "1",
                transmission_control_for_long_range_broadcast_message: 0,
                type_of_electronic_position_fixing_device: 7,
                user_id: 2_241_083,
                utc_day: 14,
                utc_hour: 11,
                utc_minute: 32,
                utc_month: 3,
                utc_second: 28,
                utc_year: 2012
              }}
  end

  test "message type 12" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,<42Lati0W:Ov=C7P6B?=Pjoihhjhqq0,2*2B") ==
             {:ok,
              %{
                channel: "A",
                checksum: "2B",
                current: "1",
                destination_id: 271_002_111,
                formatter: "VDM",
                message_id: 12,
                padding: "2",
                payload: "<42Lati0W:Ov=C7P6B?=Pjoihhjhqq0",
                repeat_indicator: 0,
                retransmit_flag: 1,
                safety_related_text: "MSG FROM 271002099",
                sequence_number: 0,
                sequential: "",
                source_id: 271_002_099,
                spare: 0,
                talker: "!AI",
                total: "1"
              }}
  end

  test "message type 13" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,=39UOj0jFs9R,0*65") ==
             {:ok,
              %{
                channel: "A",
                checksum: "65",
                current: "1",
                formatter: "VDM",
                id_1: 211_217_560,
                message_id: 13,
                padding: "0",
                payload: "=39UOj0jFs9R",
                repeat_indicator: 0,
                seq_1: 2,
                sequential: "",
                source_id: 211_378_120,
                spare: 0,
                talker: "!AI",
                total: "1"
              }}
  end

  test "message type 14" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,>5?Per18=HB1U:1@E=B0m<L,2*51") ==
             {:ok,
              %{
                channel: "A",
                checksum: "51",
                current: "1",
                formatter: "VDM",
                message_id: 14,
                padding: "2",
                payload: ">5?Per18=HB1U:1@E=B0m<L",
                repeat_indicator: 0,
                safety_related_text: "RCVD YR TEST MSG",
                sequential: "",
                source_id: 351_809_000,
                spare: 0,
                talker: "!AI",
                total: "1"
              }}
  end

  test "message type 15" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,B,?8Hw7D1HLskPD00,2*55") ==
             {:ok,
              %{
                channel: "B",
                checksum: "55",
                current: "1",
                destination_id_1: 370_995_000,
                formatter: "VDM",
                message_id: 15,
                message_id_1: 5,
                padding: "2",
                payload: "?8Hw7D1HLskPD00",
                repeat_indicator: 0,
                sequential: "",
                slot_offset_1: 0,
                source_id: 563_070_800,
                spare1: 0,
                talker: "!AI",
                total: "1"
              }}
  end

  test "message type 16" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,B,@6STUk004lQ206bCKNOBAb6SJ@5s,0*74") ==
             {:ok,
              %{
                channel: "B",
                checksum: "74",
                current: "1",
                destination_a_id: 315_920,
                destination_b_id: 230_137_673,
                formatter: "VDM",
                increment_a: 681,
                increment_b: 419,
                message_id: 16,
                offset_a: 2049,
                offset_b: 424,
                padding: "0",
                payload: "@6STUk004lQ206bCKNOBAb6SJ@5s",
                repeat_indicator: 0,
                sequential: "",
                source_id: 439_952_844,
                spare: 0,
                talker: "!AI",
                total: "1"
              }}
  end

  test "message type 17" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,A04757QAv0agH2JdGlLP7Oqa0@TGw9H170,4*5A") ==
             {:ok,
              %{
                channel: "A",
                checksum: "5A",
                current: "1",
                data: %{
                  dcdt_message_type: 9,
                  dcdt_station_id: 684,
                  dcdt_z_count: 3048,
                  dcdt_sequence_number: 7,
                  dcdt_n: 4,
                  dcdt_health: 0,
                  dcdt_dgnss_data_word: <<29, 254, 105, 1, 9, 23, 252, 150, 1, 28, 0::size(4)>>
                },
                formatter: "VDM",
                latitude: 0.035618333333333335,
                longitude: 0.13989333333333334,
                message_id: 17,
                padding: "4",
                payload: "A04757QAv0agH2JdGlLP7Oqa0@TGw9H170",
                repeat_indicator: 0,
                sequential: "",
                source_id: 4_310_302,
                spare1: 0,
                spare2: 0,
                talker: "!AI",
                total: "1"
              }}
  end

  test "message type 18" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,B,B3HOIj000H08MeW52k4F7wo5oP06,0*42") ==
             {:ok,
              %{
                channel: "B",
                checksum: "42",
                class_b_band_flag: 1,
                class_b_display_flag: 0,
                class_b_dsc_flag: 1,
                class_b_message_22_flag: 1,
                class_b_unit_flag: 1,
                cog: 35.3,
                communication_state: 393_222,
                communication_state_selector_flag: 1,
                current: "1",
                formatter: "VDM",
                latitude: 49.484455,
                longitude: 0.115565,
                message_id: 18,
                mode_flag: 0,
                padding: "0",
                payload: "B3HOIj000H08MeW52k4F7wo5oP06",
                position_accuracy: 1,
                raim_flag: 1,
                repeat_indicator: 0,
                sequential: "",
                sog: 0.1,
                spare1: 0,
                spare2: 0,
                talker: "!AI",
                time_stamp: 46,
                total: "1",
                true_heading: 511,
                user_id: 227_006_920
              }}
  end

  test "message type 19" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(
             ais,
             "!AIVDM,1,1,,B,C69DqeP0Ar8;JH3R6<4O7wWPl@:62L>jcaQgh0000000?104222P,0*32"
           ) ==
             {:ok,
              %{
                assigned_mode_flag: 0,
                channel: "B",
                checksum: "32",
                cog: 49.7,
                current: "1",
                dimension_a: 16,
                dimension_b: 8,
                dimension_c: 4,
                dimension_d: 4,
                dte: 1,
                formatter: "VDM",
                latitude: 24.695788333333333,
                longitude: 118.99442666666667,
                message_id: 19,
                name: "ZHECANGYU4078",
                padding: "0",
                payload: "C69DqeP0Ar8;JH3R6<4O7wWPl@:62L>jcaQgh0000000?104222P",
                position_accuracy: 1,
                raim_flag: 0,
                repeat_indicator: 0,
                sequential: "",
                sog: 7.1,
                spare1: 0,
                spare2: 0,
                spare3: 0,
                talker: "!AI",
                time_stamp: 15,
                total: "1",
                true_heading: 511,
                type_of_electronic_position_fixing_device: 1,
                type_of_ship_and_cargo_type: 30,
                user_id: 412_432_822
              }}
  end

  test "message type 21" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,B,E>jCfrv2`0c2h0W:0a2ah@@@@@@004WD>;2<H50hppN000,4*0A") ==
             {:ok,
              %{
                assigned_mode_flag: 0,
                aton_status: 0,
                channel: "B",
                checksum: "0A",
                current: "1",
                dimension_a: 5,
                dimension_b: 6,
                dimension_c: 7,
                dimension_d: 7,
                formatter: "VDM",
                id: 992_276_203,
                latitude: 49.536165,
                longitude: 0.0315,
                message_id: 21,
                name_of_aids_to_navigation: "EPAVE ANTARES       ",
                off_position_indicator: 0,
                padding: "4",
                payload: "E>jCfrv2`0c2h0W:0a2ah@@@@@@004WD>;2<H50hppN000",
                position_accuracy: 0,
                raim_flag: 0,
                repeat_indicator: 0,
                sequential: "",
                spare: 0,
                talker: "!AI",
                time_stamp: 60,
                total: "1",
                type_of_aids_to_navigation: 28,
                type_of_electronic_position_fixing_device: 0,
                virtual_aton_flag: 0
              }}
  end

  test "message type 22" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,B,F030p?j2N2P73FiiNesU3FR10000,0*32") ==
             {:ok,
              %{
                channel: "B",
                checksum: "32",
                current: "1",
                formatter: "VDM",
                message_id: 22,
                padding: "0",
                payload: "F030p?j2N2P73FiiNesU3FR10000",
                sequential: "",
                talker: "!AI",
                total: "1",
                addressed: 0,
                channel_a: 2087,
                channel_a_band: 0,
                channel_b: 2088,
                channel_b_band: 0,
                id: 3_160_127,
                ne_lat: 0.04841666666666666,
                ne_lon: -0.05175,
                power: 0,
                repeat_indicator: 0,
                spare1: 0,
                spare2: 0,
                sw_lat: 0.045766666666666664,
                sw_lon: -0.0565,
                tx_rx: 0,
                zone_size: 2
              }}
  end

  test "message type 23" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,B,G02:Kn01R`sn@291nj600000900,2*12") ==
             {:ok,
              %{
                channel: "B",
                checksum: "12",
                current: "1",
                formatter: "VDM",
                interval: 9,
                message_id: 23,
                ne_lat: 0.05107,
                ne_lon: 0.00263,
                padding: "2",
                payload: "G02:Kn01R`sn@291nj600000900",
                quiet: 0,
                repeat_indicator: 0,
                sequential: "",
                ship_type: 0,
                spare1: 0,
                spare2: 0,
                station_type: 6,
                sw_lat: 0.05068,
                sw_lon: 0.0018266666666666668,
                talker: "!AI",
                total: "1",
                tx_rx: 0,
                user_id: 2_268_120
              }}
  end

  test "message type 24 part A" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,H3HOIj0LhuE@tp0000000000000,2*2B") ==
             {:ok,
              %{
                channel: "A",
                checksum: "2B",
                current: "1",
                formatter: "VDM",
                message_id: 24,
                padding: "2",
                payload: "H3HOIj0LhuE@tp0000000000000",
                sequential: "",
                talker: "!AI",
                total: "1",
                repeat_indicator: 0,
                user_id: 227_006_920,
                part_number: 0,
                name: "GLOUTON"
              }}
  end

  test "message type 24 part B" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(ais, "!AIVDM,1,1,,A,H3HOIFTl00000006Gqjhm01p?650,0*4F") ==
             {:ok,
              %{
                call_sign: "FW9205",
                channel: "A",
                checksum: "4F",
                current: "1",
                dimension_a: 15,
                dimension_b: 15,
                dimension_c: 6,
                dimension_d: 5,
                formatter: "VDM",
                message_id: 24,
                padding: "0",
                part_number: 1,
                payload: "H3HOIFTl00000006Gqjhm01p?650",
                repeat_indicator: 0,
                sequential: "",
                spare: 0,
                talker: "!AI",
                total: "1",
                type_of_electronic_position_fixing_device: 0,
                type_of_ship_and_cargo_type: 52,
                user_id: 227_006_810,
                vendor_id: ""
              }}
  end

  test "message type 25" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(
             ais,
             "!AIVDM,2,1,3,A,I`1ifG20UrcNTFE?UgLeo@Dk:o6G4hhI8;?vW2?El>Deju@c3Si451FJd9WPU<>B,0*04"
           ) ==
             {:error,
              {:incomplete,
               %{
                 channel: "A",
                 checksum: "04",
                 current: "1",
                 formatter: "VDM",
                 padding: "0",
                 payload: "I`1ifG20UrcNTFE?UgLeo@Dk:o6G4hhI8;?vW2?El>Deju@c3Si451FJd9WPU<>B",
                 sequential: "3",
                 talker: "!AI",
                 total: "2"
               }}}

    assert AIS.parse(ais, "!AIVDM,2,2,3,A,gML6TO918o:?6uoOFu3k@=vE,3*41") ==
             {:ok,
              %{
                binary_data:
                  <<128, 151, 170, 222, 145, 101, 79, 150, 247, 45, 221, 5, 51, 43, 113, 151, 19,
                    12, 25, 32, 179, 254, 156, 35, 213, 208, 229, 45, 203, 212, 43, 14, 60, 68,
                    20, 21, 154, 176, 153, 224, 148, 195, 146, 189, 215, 6, 145, 242, 65, 35, 114,
                    143, 27, 221, 223, 91, 208, 243, 64, 223, 149>>,
                binary_data_flag: 0,
                channel: "A",
                checksum: "41",
                current: "2",
                destination_indicator: 0,
                formatter: "VDM",
                message_id: 25,
                padding: "3",
                payload:
                  "I`1ifG20UrcNTFE?UgLeo@Dk:o6G4hhI8;?vW2?El>Deju@c3Si451FJd9WPU<>BgML6TO918o:?6uoOFu3k@=vE",
                repeat_indicator: 2,
                sequential: "3",
                source_id: 538_734_172,
                talker: "!AI",
                total: "2"
              }}
  end

  test "message type 27" do
    {:ok, ais} = AIS.new()
    assert AIS.get(ais) == []

    assert AIS.parse(
             ais,
             "!AIVDM,1,1,,A,KCQ9r=hrFUnH7P00,0*41"
           ) ==
             {:ok,
              %{
                channel: "A",
                checksum: "41",
                cog: 0,
                current: "1",
                formatter: "VDM",
                latitude: 87.065,
                longitude: -154.20166666666665,
                message_id: 27,
                navigational_status: 3,
                padding: "0",
                payload: "KCQ9r=hrFUnH7P00",
                position_accuracy: 0,
                position_latency: 0,
                raim_flag: 0,
                repeat_indicator: 1,
                sequential: "",
                sog: 0,
                spare: 0,
                talker: "!AI",
                total: "1",
                user_id: 236_091_959
              }}
  end
end
