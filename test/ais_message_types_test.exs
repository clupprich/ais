defmodule AisMessageTypesTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  test_with_params "test known ais messages id",
                   fn expected, msg, struct ->
                     {:ok, ais} = AIS.new()
                     assert AIS.get(ais) == []

                     {result, _} = AIS.parse(ais, msg)
                     assert result == :ok
                     assert AIS.parse(ais, msg) == {expected, struct}
                   end do
    [
      # 1
      {:ok, "!AIVDM,1,1,,B,13IbQQ000100lq`LD7J6Vi<n88AM,0*52",
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
       }},
      # 2
      {:ok, "!AIVDM,1,1,,A,23aDrf0P12PBCNpMKVQ4OOvfR0S0,0*3E", %{
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
        user_id: 244660920
      }},
      # 3
      {:ok, "!AIVDM,1,1,,B,39NSDjP02201T0HLBJDBv2GD02s1,0*14",
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
       }},
      # 4
      {:ok, "!AIVDM,1,1,,A,402;bFQv@kkLc00Dl4LE52100@J6,0*58",
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
       }},
      # 5 (only fragmented messages)
      # 6
      {:ok, "!AIVDM,1,1,,A,6>jCKIkfJjOt>db;q700@20,2*16",
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
       }},
      # 7
      {:ok, "!AIVDM,1,1,,A,777QkG00RW38,0*62",
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
         total: "1"
       }},
      # 8
      {:ok, "!AIVDM,1,1,,A,83HT5APj2P00000001BQJ@2E0000,0*72",
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
         designated_area_code: 200,
         functional_id: 10,
         data: <<0, 0, 0, 0, 0, 0, 20, 161, 105, 0, 149, 0, 0, 0>>
       }},
      # 9
      {:ok, "!AIVDM,1,1,,B,91b55vRAirOn<94M097lV@@20<6=,0*5D",
       %{
         altitude: 583,
         altitude_sensor: 0,
         assigned_mode_flag: 0,
         channel: "B",
         checksum: "5D",
         cog: 1177,
         communication_state: 49549,
         communication_state_selector_flag: 0,
         current: "1",
         dte: 1,
         formatter: "VDM",
         latitude: 30_411_039,
         longitude: 267_149_602,
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
       }},
      # 10
      {:ok, "!AIVDM,1,1,,A,:81:Jf1D02J0,0*0E",
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
       }},
      # 11
      {:ok, "!AIVDM,1,1,,A,;028j>iuho;PLO0ARF@EEmG008AG,0*31", %{
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
        user_id: 2241083,
        utc_day: 14,
        utc_hour: 11,
        utc_minute: 32,
        utc_month: 3,
        utc_second: 28,
        utc_year: 2012
      }},
      # 15
      # 16
      {:ok, "!AIVDM,1,1,,B,@6STUk004lQ206bCKNOBAb6SJ@5s,0*74",
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
       }},
      # 17
      {:ok, "!AIVDM,1,1,,A,A04757QAv0agH2JdGlLP7Oqa0@TGw9H170,4*5A",
       %{
         channel: "A",
         checksum: "5A",
         current: "1",
         data: <<38, 172, 95, 71, 32, 29, 254, 105, 1, 9, 23, 252, 150, 1, 28, 0::size(4)>>,
         formatter: "VDM",
         latitude: 21371,
         longitude: 83936,
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
       }},
      # 18
      {:ok, "!AIVDM,1,1,,B,B3HOIj000H08MeW52k4F7wo5oP06,0*42",
       %{
         channel: "B",
         checksum: "42",
         class_b_band_flag: 1,
         class_b_display_flag: 0,
         class_b_dsc_flag: 1,
         class_b_message_22_flag: 1,
         class_b_unit_flag: 1,
         cog: 353,
         communication_state: 393_222,
         communication_state_selector_flag: 1,
         current: "1",
         formatter: "VDM",
         latitude: 29_690_673,
         longitude: 69339,
         message_id: 18,
         mode_flag: 0,
         padding: "0",
         payload: "B3HOIj000H08MeW52k4F7wo5oP06",
         position_accuracy: 1,
         raim_flag: 1,
         repeat_indicator: 0,
         sequential: "",
         sog: 1,
         spare1: 0,
         spare2: 0,
         talker: "!AI",
         time_stamp: 46,
         total: "1",
         true_heading: 511,
         user_id: 227_006_920
       }},
      # 19
      {:ok, "!AIVDM,1,1,,B,C69DqeP0Ar8;JH3R6<4O7wWPl@:62L>jcaQgh0000000?104222P,0*32",
       %{
         assigned_mode_flag: 0,
         channel: "B",
         checksum: "32",
         cog: 497,
         current: "1",
         dimension_a: 16,
         dimension_b: 8,
         dimension_c: 4,
         dimension_d: 4,
         dte: 1,
         formatter: "VDM",
         latitude: 14_817_473,
         longitude: 71_396_656,
         message_id: 19,
         name: "ZHECANGYU4078",
         padding: "0",
         payload: "C69DqeP0Ar8;JH3R6<4O7wWPl@:62L>jcaQgh0000000?104222P",
         position_accuracy: 1,
         raim_flag: 0,
         repeat_indicator: 0,
         sequential: "",
         sog: 71,
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
       }},
      # 21
      {:ok, "!AIVDM,1,1,,B,E>jCfrv2`0c2h0W:0a2ah@@@@@@004WD>;2<H50hppN000,4*0A",
       %{
         assigned_mode_flag: 0,
         aton_status: 0,
         channel: "B",
         checksum: "0A",
         current: "1",
         dimension: 10_510_791,
         formatter: "VDM",
         id: 992_276_203,
         latitude: 29_721_699,
         longitude: 18900,
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
       }},
      # 22
      {:ok, "!AIVDM,1,1,,B,F030p?j2N2P73FiiNesU3FR10000,0*32",
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
         total: "1"
       }},
      # 23 (only fragmented messages)
      # 24 A
      {:ok, "!AIVDM,1,1,,A,H3HOIj0LhuE@tp0000000000000,2*2B",
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
       }},
      # 24 B
      {:ok, "!AIVDM,1,1,,A,H3HOIFTl00000006Gqjhm01p?650,0*4F",
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
         vendor_id: 0
       }}
      # 25 (only fragmented messages)
    ]
  end
end
