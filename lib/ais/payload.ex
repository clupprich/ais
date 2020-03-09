defmodule AIS.Payload do
  @moduledoc """
  Handle decoding of the AIS Payload to a convenient `Map`.
  """

  @doc """
  Parse an AIS payload.

  Takes a `bitstring()` and return `{:ok, Map}` when decoding succeede, or `{:invalid, %{}}`.
  """

  # See https://www.itu.int/dms_pubrec/itu-r/rec/m/R-REC-M.1371-1-200108-S!!PDF-E.pdf
  # for packet formats

  @spec parse(binary()) :: {:invalid, %{}} | {:ok, any()}
  def parse(payload) do
    orig_payload = payload
    payload = SixBit.decode(payload)

    <<message_id::6, tail::bitstring>> = payload

    try do
      attributes = parse_message(message_id, tail)
      {:ok, Map.merge(%{message_id: message_id}, attributes)}
    rescue
      e in MatchError ->
        IO.puts(
          "Error decoding message type #{message_id} '#{orig_payload}': " <> Exception.message(e)
        )

        {:invalid, %{}}
    end
  end

  # Class A AIS Position Report (Messages 1, 2, and 3)
  # https://www.navcen.uscg.gov/?pageName=AISMessagesA
  # !AIVDM,1,1,,B,13IbQQ000100lq`LD7J6Vi<n88AM,0*52  ID 1
  # !AIVDM,1,1,,B,39NSDjP02201T0HLBJDBv2GD02s1,0*14  ID 3
  defp parse_message(message_id, payload)
       when message_id == 1 or message_id == 2 or message_id == 3 do
    <<repeat_indicator::2, user_id::30, navigational_status::4,
      rate_of_turn::integer-signed-size(8), sog::integer-unsigned-size(10), position_accuracy::1,
      longitude::integer-signed-size(28), latitude::integer-signed-size(27), cog::12,
      true_heading::9, time_stamp::6, special_maneuvre_indicator::2, spare::3, raim_flag::1,
      communication_state::19, _::bitstring>> = payload

    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      navigational_status: navigational_status,
      rate_of_turn: rate_of_turn,
      sog: sog / 10.0,
      position_accuracy: position_accuracy,
      longitude: longitude / 600_000.0,
      latitude: latitude / 600_000.0,
      cog: cog / 10.0,
      true_heading: true_heading,
      time_stamp: time_stamp,
      special_maneuvre_indicator: special_maneuvre_indicator,
      spare: spare,
      raim_flag: raim_flag,
      communication_state: communication_state
    }
  end

  # AIS Base Station Report (Message 4) And Coordinated Universal Time And Date Response (Message 11)
  # https://www.navcen.uscg.gov/?pageName=AIS_Base_Station_Report
  # !AIVDM,1,1,,A,402;bFQv@kkLc00Dl4LE52100@J6,0*58  ID 4
  defp parse_message(message_id, payload) when message_id == 4 or message_id == 11 do
    <<repeat_indicator::2, user_id::30, utc_year::14, utc_month::4, utc_day::5, utc_hour::5,
      utc_minute::6, utc_second::6, position_accuracy::1, longitude::integer-signed-size(28),
      latitude::integer-signed-size(27), type_of_electronic_position_fixing_device::4,
      transmission_control_for_long_range_broadcast_message::1, spare::9, raim_flag::1,
      communication_state::19, _::bitstring>> = payload

    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      utc_year: utc_year,
      utc_month: utc_month,
      utc_day: utc_day,
      utc_hour: utc_hour,
      utc_minute: utc_minute,
      utc_second: utc_second,
      position_accuracy: position_accuracy,
      longitude: longitude / 600_000.0,
      latitude: latitude / 600_000.0,
      type_of_electronic_position_fixing_device: type_of_electronic_position_fixing_device,
      transmission_control_for_long_range_broadcast_message:
        transmission_control_for_long_range_broadcast_message,
      spare: spare,
      raim_flag: raim_flag,
      communication_state: communication_state
    }
  end

  # AIS Class A Ship Static And Voyage Related Data (Message 5)
  # https://www.navcen.uscg.gov/?pageName=AISMessagesAStatic
  # !AIVDM,2,1,9,B,53qH`N0286j=<p8b220ti`62222222222222221?9p;554oF0;B3k51CPEH8,0*58
  # !AIVDM,2,2,9,B,88888888880,2*2E
  defp parse_message(message_id, payload) when message_id == 5 do
    <<repeat_indicator::2, user_id::30, ais_version_indicator::2, imo_number::30, call_sign::42,
      name::120, type_of_ship_and_cargo_type::8, dimension_a::9, dimension_b::9, dimension_c::6,
      dimension_d::6, type_of_electronic_position_fixing_device::4, eta_month::4, eta_day::5,
      eta_hour::5, eta_minute::6, maximum_present_static_draught::8, destination::120, dte::1,
      spare::1, _::bitstring>> = payload

    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      ais_version_indicator: ais_version_indicator,
      imo_number: imo_number,
      call_sign: SixBit.get_string(call_sign, 42),
      name: SixBit.get_string(name, 120),
      type_of_ship_and_cargo_type: type_of_ship_and_cargo_type,
      dimension_a: dimension_a,
      dimension_b: dimension_b,
      dimension_c: dimension_c,
      dimension_d: dimension_d,
      type_of_electronic_position_fixing_device: type_of_electronic_position_fixing_device,
      eta: %{
        month: eta_month,
        day: eta_day,
        hour: eta_hour,
        minute: eta_minute
      },
      maximum_present_static_draught: maximum_present_static_draught / 10.0,
      destination: SixBit.get_string(destination, 120),
      dte: dte,
      spare: spare
    }
  end

  # AIS Binary Addressed Message (Message 6)
  # https://www.navcen.uscg.gov/?pageName=AISMessage6
  # !AIVDM,1,1,,A,6>jCKIkfJjOt>db;q700@20,2*16
  defp parse_message(message_id, payload) when message_id == 6 do
    <<repeat_indicator::2, source_id::30, sequence_number::2, destination_id::30,
      retransmit_flag::1, spare::1, application_identifier::16,
      application_data::bitstring>> = payload

    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      sequence_number: sequence_number,
      destination_id: destination_id,
      retransmit_flag: retransmit_flag,
      spare: spare,
      application_identifier: application_identifier,
      application_data: application_data
    }
  end

  # AIS Binary Acknowledgment Message (Message 7)
  # https://gpsd.gitlab.io/gpsd/AIVDM.html#_type_7_binary_acknowledge
  # !AIVDM,1,1,,A,777QkG00RW38,0*62
  # 4 destinations
  defp parse_message(
         message_id,
         <<repeat_indicator::2, source_id::30, spare::2, id_1::30, seq_1::2, id_2::30, seq_2::2,
           id_3::30, seq_3::2, id_4::30, seq_4::2, _::bitstring>>
       )
       when message_id == 7 or message_id == 13 do
    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare: spare,
      id_1: id_1,
      seq_1: seq_1,
      id_2: id_2,
      seq_2: seq_2,
      id_3: id_3,
      seq_3: seq_3,
      id_4: id_4,
      seq_4: seq_4
    }
  end

  # 3 destinations
  defp parse_message(
         message_id,
         <<repeat_indicator::2, source_id::30, spare::2, id_1::30, seq_1::2, id_2::30, seq_2::2,
           id_3::30, seq_3::2, _::bitstring>>
       )
       when message_id == 7 or message_id == 13 do
    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare: spare,
      id_1: id_1,
      seq_1: seq_1,
      id_2: id_2,
      seq_2: seq_2,
      id_3: id_3,
      seq_3: seq_3
    }
  end

  # 2 destinations
  defp parse_message(
         message_id,
         <<repeat_indicator::2, source_id::30, spare::2, id_1::30, seq_1::2, id_2::30, seq_2::2,
           _::bitstring>>
       )
       when message_id == 7 or message_id == 13 do
    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare: spare,
      id_1: id_1,
      seq_1: seq_1,
      id_2: id_2,
      seq_2: seq_2
    }
  end

  # 1 destination
  defp parse_message(
         message_id,
         <<repeat_indicator::2, source_id::30, spare::2, id_1::30, seq_1::2, _::bitstring>>
       )
       when message_id == 7 or message_id == 13 do
    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare: spare,
      id_1: id_1,
      seq_1: seq_1
    }
  end

  # AIS Binary Broadcast Message (Message 8)
  # https://www.navcen.uscg.gov/?pageName=AISMessage8
  # !AIVDM,1,1,,A,83HT5APj2P00000001BQJ@2E0000,0*72
  defp parse_message(message_id, payload) when message_id == 8 do
    <<repeat_indicator::2, source_id::30, spare::2, application_identifier::16, data::bitstring>> =
      payload

    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare: spare,
      application_identifier: application_identifier,
      data: data
    }
  end

  # AIS STANDARD SEARCH AND RESCUE AIRCRAFT POSITION REPORT (MESSAGE 9)
  # https://www.navcen.uscg.gov/?pageName=AISMessage9
  # !AIVDM,1,1,,B,91b55vRAirOn<94M097lV@@20<6=,0*5D
  defp parse_message(
         message_id,
         <<repeat_indicator::2, user_id::30, altitude::12, sog::10, position_accuracy::1,
           longitude::integer-signed-size(28), latitude::integer-signed-size(27), cog::12,
           time_stamp::6, altitude_sensor::1, spare1::7, dte::1, spare2::3, assigned_mode_flag::1,
           raim_flag::1, communication_state_selector_flag::1, communication_state::19>>
       )
       when message_id == 9 do
    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      altitude: altitude,
      sog: sog,
      position_accuracy: position_accuracy,
      longitude: longitude / 600_000.0,
      latitude: latitude / 600_000.0,
      cog: cog / 10,
      time_stamp: time_stamp,
      altitude_sensor: altitude_sensor,
      spare1: spare1,
      dte: dte,
      spare2: spare2,
      assigned_mode_flag: assigned_mode_flag,
      raim_flag: raim_flag,
      communication_state_selector_flag: communication_state_selector_flag,
      communication_state: communication_state
    }
  end

  # AIS COORDINATED UNIVERSAL TIME AND DATE INQUIRY (MESSAGE 10)
  # https://www.navcen.uscg.gov/?pageName=AIS_Base_Station_Report
  # !AIVDM,1,1,,A,:81:Jf1D02J0,0*0E
  defp parse_message(message_id, payload) when message_id == 10 do
    <<repeat_indicator::2, source_id::30, spare1::2, destination_id::30, spare2::2>> = payload

    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare1: spare1,
      destination_id: destination_id,
      spare2: spare2
    }
  end

  # AIS ADDRESSED SAFETY RELATED MESSAGE (MESSAGE 12)
  # https://www.navcen.uscg.gov/?pageName=AISMessage12
  # !AIVDM,1,1,,A,<42Lati0W:Ov=C7P6B?=Pjoihhjhqq0,2*2B
  defp parse_message(message_id, payload) when message_id == 12 do
    <<repeat_indicator::2, source_id::30, sequence_number::2, destination_id::30,
      retransmit_flag::1, spare::1, safety_related_text::bitstring>> = payload

    safety_text_size = Kernel.floor(bit_size(safety_related_text) / 6) * 6
    <<safety_text::size(safety_text_size), _::bitstring>> = safety_related_text

    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      sequence_number: sequence_number,
      destination_id: destination_id,
      retransmit_flag: retransmit_flag,
      spare: spare,
      safety_related_text: SixBit.get_string(safety_text, safety_text_size)
    }
  end

  # AIS SAFETY RELATED BROADCAST MESSAGE (MESSAGE 14)
  # https://www.navcen.uscg.gov/?pageName=AISMessage14
  # !AIVDM,1,1,,A,>5?Per18=HB1U:1@E=B0m<L,2*51
  defp parse_message(message_id, payload) when message_id == 14 do
    <<repeat_indicator::2, source_id::30, spare::2, safety_related_text::bitstring>> = payload

    safety_text_size = Kernel.floor(bit_size(safety_related_text) / 6) * 6
    <<safety_text::size(safety_text_size), _::bitstring>> = safety_related_text

    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare: spare,
      safety_related_text: SixBit.get_string(safety_text, safety_text_size)
    }
  end

  # Interrogation (Message 15)
  # https://www.navcen.uscg.gov/pdf/AIS/ITU_R_M_1371_5_3_13_Message_15.pdf
  #
  # Also has spurious datas at the end
  # The first station is interrogated two (2) messages, and the second station is interrogated one(1) message: All parameters should be defined
  # same as
  # The  first  station  and  the  second  station  are  interrogated  one  (1)  message  each:
  # The  parameters  destination  ID1,  message  ID1.1,  slot  offset  1.1,  destination  ID2,
  # message ID2.1, and slot offset 2.1 should be defined.
  # The parameters message ID1.2 and slot offset 1.2 should be set to zero (0)
  defp parse_message(
         message_id,
         <<repeat_indicator::2, source_id::30, spare1::2, destination_id_1::30, message_id_1::6,
           slot_offset_1::12, spare2::2, message_id_1_2::6, slot_offset_1_2::12, spare3::2,
           destination_id_2::30, message_id_2::6, slot_offset_2::12, spare4::2, _::bitstring>>
       )
       when message_id == 15 do
    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare1: spare1,
      destination_id_1: destination_id_1,
      message_id_1: message_id_1,
      slot_offset_1: slot_offset_1,
      spare2: spare2,
      message_id_1_2: message_id_1_2,
      slot_offset_1_2: slot_offset_1_2,
      spare3: spare3,
      destination_id_2: destination_id_2,
      message_id_2: message_id_2,
      slot_offset_2: slot_offset_2,
      spare4: spare4
    }
  end

  # One  (1)  station  is  interrogated  two  (2)  messages:  The  parameters  destination  ID1,  message  ID1.1,  slot  offset  1.1,  message  ID1.2,
  # and  slot  offset  1.2  should  be  defined. The parameters destination ID2, message ID2.1, and slot offset 2.1 should be omitted.
  defp parse_message(
         message_id,
         <<repeat_indicator::2, source_id::30, spare1::2, destination_id_1::30, message_id_1::6,
           slot_offset_1::12, spare2::2, message_id_1_2::6, slot_offset_1_2::12, _::bitstring>>
       )
       when message_id == 15 do
    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare1: spare1,
      destination_id_1: destination_id_1,
      message_id_1: message_id_1,
      slot_offset_1: slot_offset_1,
      spare2: spare2,
      message_id_1_2: message_id_1_2,
      slot_offset_1_2: slot_offset_1_2
    }
  end

  # One (1) station is interrogated one (1) message: The parameters destination ID1, message ID1.1 and slot offset 1.1
  # should be defined. All other parameters should be omitted.
  defp parse_message(
         message_id,
         <<repeat_indicator::2, source_id::30, spare1::2, destination_id_1::30, message_id_1::6,
           slot_offset_1::12, _::bitstring>>
       )
       when message_id == 15 do
    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare1: spare1,
      destination_id_1: destination_id_1,
      message_id_1: message_id_1,
      slot_offset_1: slot_offset_1
    }
  end

  # Assignment mode command (Message 16)
  # !AIVDM,1,1,,B,@6STUk004lQ206bCKNOBAb6SJ@5s,0*74
  defp parse_message(
         message_id,
         <<repeat_indicator::2, source_id::30, spare::2, destination_a_id::30, offset_a::12,
           increment_a::10, destination_b_id::30, offset_b::12, increment_b::10, _::bitstring>>
       )
       when message_id == 16 do
    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare: spare,
      destination_a_id: destination_a_id,
      offset_a: offset_a,
      increment_a: increment_a,
      destination_b_id: destination_b_id,
      offset_b: offset_b,
      increment_b: increment_b
    }
  end

  # AIS GLOBAL NAVIGATION-SATELLITE SYSTEM BROADCAST BINARY MESSAGE (MESSAGE 17)
  # https://www.navcen.uscg.gov/?pageName=AISMessage17
  # !AIVDM,1,1,,A,A04757QAv0agH2JdGlLP7Oqa0@TGw9H170,4*5A
  defp parse_message(
         message_id,
         <<repeat_indicator::2, source_id::30, spare1::2, longitude::integer-signed-size(18),
           latitude::integer-signed-size(17), spare2::5, data::bitstring>>
       )
       when message_id == 17 do
    # Legacy DGNSS datas
    <<dcdt_message_type::6, dcdt_station_id::10, dcdt_z_count::13, dcdt_sequence_number::3,
      dcdt_n::5, dcdt_health::3, dcdt_dgnss_data_word::bitstring>> = data

    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare1: spare1,
      longitude: longitude / 600_000.0,
      latitude: latitude / 600_000.0,
      spare2: spare2,
      data: %{
        dcdt_message_type: dcdt_message_type,
        dcdt_station_id: dcdt_station_id,
        dcdt_z_count: dcdt_z_count,
        dcdt_sequence_number: dcdt_sequence_number,
        dcdt_n: dcdt_n,
        dcdt_health: dcdt_health,
        dcdt_dgnss_data_word: dcdt_dgnss_data_word
      }
    }
  end

  # AIS Standard Class B Equipment Position Report (Message 18)
  # https://www.navcen.uscg.gov/?pageName=AISMessagesB
  # !AIVDM,1,1,,B,B3HOIj000H08MeW52k4F7wo5oP06,0*42
  # Seems to have spurious datas sometime at the end or undocumented values
  defp parse_message(message_id, payload) when message_id == 18 do
    <<repeat_indicator::2, user_id::30, spare1::8, sog::10, position_accuracy::1,
      longitude::integer-signed-size(28), latitude::integer-signed-size(27), cog::12,
      true_heading::9, time_stamp::6, spare2::2, class_b_unit_flag::1, class_b_display_flag::1,
      class_b_dsc_flag::1, class_b_band_flag::1, class_b_message_22_flag::1, mode_flag::1,
      raim_flag::1, communication_state_selector_flag::1, communication_state::19,
      _::bitstring>> = payload

    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      spare1: spare1,
      sog: sog / 10.0,
      position_accuracy: position_accuracy,
      longitude: longitude / 600_000.0,
      latitude: latitude / 600_000.0,
      cog: cog / 10.0,
      true_heading: true_heading,
      time_stamp: time_stamp,
      spare2: spare2,
      class_b_unit_flag: class_b_unit_flag,
      class_b_display_flag: class_b_display_flag,
      class_b_dsc_flag: class_b_dsc_flag,
      class_b_band_flag: class_b_band_flag,
      class_b_message_22_flag: class_b_message_22_flag,
      mode_flag: mode_flag,
      raim_flag: raim_flag,
      communication_state_selector_flag: communication_state_selector_flag,
      communication_state: communication_state
    }
  end

  # MESSAGE 19: EXTENDED CLASS B EQUIPMENT POSITION REPORT (legacy)
  # https://www.navcen.uscg.gov/?pageName=AISMessagesB
  # !AIVDM,1,1,,B,C69DqeP0Ar8;JH3R6<4O7wWPl@:62L>jcaQgh0000000?104222P,0*32
  defp parse_message(
         message_id,
         <<repeat_indicator::2, user_id::30, spare1::8, sog::10, position_accuracy::1,
           longitude::integer-signed-size(28), latitude::integer-signed-size(27), cog::12,
           true_heading::9, time_stamp::6, spare2::4, name::120, type_of_ship_and_cargo_type::8,
           dimension_a::9, dimension_b::9, dimension_c::6, dimension_d::6,
           type_of_electronic_position_fixing_device::4, raim_flag::1, dte::1,
           assigned_mode_flag::1, spare3::4>>
       )
       when message_id == 19 do
    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      spare1: spare1,
      sog: sog / 10.0,
      position_accuracy: position_accuracy,
      longitude: longitude / 600_000.0,
      latitude: latitude / 600_000.0,
      cog: cog / 10.0,
      true_heading: true_heading,
      time_stamp: time_stamp,
      spare2: spare2,
      name: SixBit.get_string(name, 120),
      type_of_ship_and_cargo_type: type_of_ship_and_cargo_type,
      dimension_a: dimension_a,
      dimension_b: dimension_b,
      dimension_c: dimension_c,
      dimension_d: dimension_d,
      type_of_electronic_position_fixing_device: type_of_electronic_position_fixing_device,
      raim_flag: raim_flag,
      dte: dte,
      assigned_mode_flag: assigned_mode_flag,
      spare3: spare3
    }
  end

  # Data link management message
  # https://gpsd.gitlab.io/gpsd/AIVDM.html#_type_20_data_link_management_message
  # !AIVDM,1,1,,A,Dh3OvjB8IN>4,0*1D
  # 4 offsets
  defp parse_message(
         message_id,
         <<repeat_indicator::2, id::30, _::2, offset_1::12, slots_1::4, timeout_1::3,
           increment_1::11, offset_2::12, slots_2::4, timeout_2::3, increment_2::11, offset_3::12,
           slots_3::4, timeout_3::3, increment_3::11, offset_4::12, slots_4::4, timeout_4::3,
           increment_4::11, _::bitstring>>
       )
       when message_id == 20 do
    %{
      repeat_indicator: repeat_indicator,
      id: id,
      offset_1: offset_1,
      slots_1: slots_1,
      timeout_1: timeout_1,
      increment_1: increment_1,
      offset_2: offset_2,
      slots_2: slots_2,
      timeout_2: timeout_2,
      increment_2: increment_2,
      offset_3: offset_3,
      slots_3: slots_3,
      timeout_3: timeout_3,
      increment_3: increment_3,
      offset_4: offset_4,
      slots_4: slots_4,
      timeout_4: timeout_4,
      increment_4: increment_4
    }
  end

  # 3 offsets
  defp parse_message(
         message_id,
         <<repeat_indicator::2, id::30, _::2, offset_1::12, slots_1::4, timeout_1::3,
           increment_1::11, offset_2::12, slots_2::4, timeout_2::3, increment_2::11, offset_3::12,
           slots_3::4, timeout_3::3, increment_3::11, _::bitstring>>
       )
       when message_id == 20 do
    %{
      repeat_indicator: repeat_indicator,
      id: id,
      offset_1: offset_1,
      slots_1: slots_1,
      timeout_1: timeout_1,
      increment_1: increment_1,
      offset_2: offset_2,
      slots_2: slots_2,
      timeout_2: timeout_2,
      increment_2: increment_2,
      offset_3: offset_3,
      slots_3: slots_3,
      timeout_3: timeout_3,
      increment_3: increment_3
    }
  end

  # 2 offsets
  defp parse_message(
         message_id,
         <<repeat_indicator::2, id::30, _::2, offset_1::12, slots_1::4, timeout_1::3,
           increment_1::11, offset_2::12, slots_2::4, timeout_2::3, increment_2::11,
           _::bitstring>>
       )
       when message_id == 20 do
    %{
      repeat_indicator: repeat_indicator,
      id: id,
      offset_1: offset_1,
      slots_1: slots_1,
      timeout_1: timeout_1,
      increment_1: increment_1,
      offset_2: offset_2,
      slots_2: slots_2,
      timeout_2: timeout_2,
      increment_2: increment_2
    }
  end

  # 1 offset
  defp parse_message(
         message_id,
         <<repeat_indicator::2, id::30, _::2, offset_1::12, slots_1::4, timeout_1::3,
           increment_1::11, _::bitstring>>
       )
       when message_id == 20 do
    %{
      repeat_indicator: repeat_indicator,
      id: id,
      offset_1: offset_1,
      slots_1: slots_1,
      timeout_1: timeout_1,
      increment_1: increment_1
    }
  end

  # AIS Aids To Navigation (ATON) Report (Message 21)
  # https://www.navcen.uscg.gov/?pageName=AISMessage21
  # !AIVDM,1,1,,B,E>jCfrv2`0c2h0W:0a2ah@@@@@@004WD>;2<H50hppN000,4*0A
  defp parse_message(message_id, payload) when message_id == 21 do
    <<repeat_indicator::2, id::30, type_of_aids_to_navigation::5, name_of_aids_to_navigation::120,
      position_accuracy::1, longitude::integer-signed-size(28), latitude::integer-signed-size(27),
      dimension_a::9, dimension_b::9, dimension_c::6, dimension_d::6,
      type_of_electronic_position_fixing_device::4, time_stamp::6, off_position_indicator::1,
      aton_status::8, raim_flag::1, virtual_aton_flag::1, assigned_mode_flag::1, spare::1,
      _::bitstring>> = payload

    # TODO Extra dynamic fields after the last spare:
    #  Name of Aid-to-Navigation Extension 	0, 6, 12, 18, 24, 30, 36, ... 84
    #  Spare 	0, 2, 4, or 6
    %{
      repeat_indicator: repeat_indicator,
      id: id,
      type_of_aids_to_navigation: type_of_aids_to_navigation,
      name_of_aids_to_navigation: SixBit.get_string(name_of_aids_to_navigation, 120),
      position_accuracy: position_accuracy,
      longitude: longitude / 600_000.0,
      latitude: latitude / 600_000.0,
      dimension_a: dimension_a,
      dimension_b: dimension_b,
      dimension_c: dimension_c,
      dimension_d: dimension_d,
      type_of_electronic_position_fixing_device: type_of_electronic_position_fixing_device,
      time_stamp: time_stamp,
      off_position_indicator: off_position_indicator,
      aton_status: aton_status,
      raim_flag: raim_flag,
      virtual_aton_flag: virtual_aton_flag,
      assigned_mode_flag: assigned_mode_flag,
      spare: spare
    }
  end

  # Channel management
  # https://www.itu.int/dms_pubrec/itu-r/rec/m/R-REC-M.1371-1-200108-S!!PDF-E.pdf page 66
  # !AIVDM,1,1,,B,F030p?j2N2P73FiiNesU3FR10000,0*32
  # !AIVDM,1,1,,B,F030pD22N2P5iQAoR;H6SQ010000,0*7F
  defp parse_message(message_id, payload) when message_id == 22 do
    <<repeat_indicator::2, id::30, spare1::2, channel_a::12, channel_b::12, tx_rx::4, power::1,
      ne_lon::integer-signed-size(18), ne_lat::integer-signed-size(17),
      sw_lon::integer-signed-size(18), sw_lat::integer-signed-size(17), addressed::1,
      channel_a_band::1, channel_b_band::1, zone_size::3, spare2::23>> = payload

    %{
      repeat_indicator: repeat_indicator,
      id: id,
      spare1: spare1,
      channel_a: channel_a,
      channel_b: channel_b,
      tx_rx: tx_rx,
      power: power,
      ne_lon: ne_lon / 600_000.0,
      ne_lat: ne_lat / 600_000.0,
      sw_lon: sw_lon / 600_000.0,
      sw_lat: sw_lat / 600_000.0,
      addressed: addressed,
      channel_a_band: channel_a_band,
      channel_b_band: channel_b_band,
      zone_size: zone_size,
      spare2: spare2
    }
  end

  # Group assignment command
  # https://gpsd.gitlab.io/gpsd/AIVDM.html#_type_23_group_assignment_command
  # !AIVDM,1,1,,B,G02:Kn01R`sn@291nj600000900,2*12
  defp parse_message(message_id, payload) when message_id == 23 do
    <<repeat_indicator::2, user_id::30, spare1::2, ne_lon::18, ne_lat::17, sw_lon::18, sw_lat::17,
      station_type::4, ship_type::8, spare2::22, tx_rx::2, interval::4, quiet::4,
      _::bitstring>> = payload

    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      spare1: spare1,
      ne_lon: ne_lon / 600_000.0,
      ne_lat: ne_lat / 600_000.0,
      sw_lon: sw_lon / 600_000.0,
      sw_lat: sw_lat / 600_000.0,
      station_type: station_type,
      ship_type: ship_type,
      spare2: spare2,
      tx_rx: tx_rx,
      interval: interval,
      quiet: quiet
    }
  end

  # MESSAGE 24: STATIC DATA REPORT (PART B)
  # !AIVDM,1,1,,A,H3HOIFTl00000006Gqjhm01p?650,0*4F     Part B
  # part_number=1 when part B
  # Pattern-matching magic: B is before A
  defp parse_message(
         message_id,
         <<repeat_indicator::2, user_id::30, part_number::2, type_of_ship_and_cargo_type::8,
           vendor_id::42, call_sign::42, dimension_a::9, dimension_b::9, dimension_c::6,
           dimension_d::6, type_of_electronic_position_fixing_device::4, spare::2>>
       )
       when message_id == 24 do
    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      part_number: part_number,
      type_of_ship_and_cargo_type: type_of_ship_and_cargo_type,
      vendor_id: SixBit.get_string(vendor_id, 42),
      call_sign: SixBit.get_string(call_sign, 42),
      dimension_a: dimension_a,
      dimension_b: dimension_b,
      dimension_c: dimension_c,
      dimension_d: dimension_d,
      type_of_electronic_position_fixing_device: type_of_electronic_position_fixing_device,
      spare: spare
    }
  end

  # MESSAGE 24: STATIC DATA REPORT (PART A)
  # https://www.navcen.uscg.gov/?pageName=AISMessagesB
  # !AIVDM,1,1,,A,H3HOIj0LhuE@tp0000000000000,2*2B      Part A
  # part_number=0 when part A
  # For some reasons some spurious datas seems present sometime after the name
  defp parse_message(
         message_id,
         <<repeat_indicator::2, user_id::30, part_number::2, name::120, _::bitstring>>
       )
       when message_id == 24 do
    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      part_number: part_number,
      name: SixBit.get_string(name, 120)
    }
  end

  # AIS SINGLE SLOT BINARY MESSAGE (MESSAGE 25)
  # https://www.navcen.uscg.gov/?pageName=AISMessage25
  # !AIVDM,2,1,3,A,I`1ifG20UrcNTFE?UgLeo@Dk:o6G4hhI8;?vW2?El>Deju@c3Si451FJd9WPU<>B,0*04
  # !AIVDM,2,2,3,A,gML6TO918o:?6uoOFu3k@=vE,3*41
  defp parse_message(message_id, payload) when message_id == 25 do
    <<repeat_indicator::2, source_id::30, destination_indicator::1, binary_data_flag::1,
      bindata::bitstring>> = payload

    msg = %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      destination_indicator: destination_indicator,
      binary_data_flag: binary_data_flag
    }

    # Add destination_id and spare if destination_indicator == 0 else ignore it
    msg =
      if destination_indicator == 1 do
        <<destination_id::30, spare::2>> = bindata

        msg
        |> Map.put(:destination_id, destination_id)
        |> Map.put(:spare, spare)
      else
        msg
      end

    msg =
      if binary_data_flag == 1 do
        <<application_identifier::16, binary_data::bitstring>> = bindata

        msg
        |> Map.put(:application_identifier, application_identifier)
        |> Map.put(:binary_data, binary_data)
      else
        <<binary_data::bitstring>> = bindata
        Map.put(msg, :binary_data, binary_data)
      end

    msg
  end

  # MULTIPLE SLOT BINARY MESSAGE WITH COMMUNICATIONS STATE (MESSAGE 26)
  # https://www.navcen.uscg.gov/?pageName=AISMessage26
  # !AIVDM,1,1,,A,J1@@0IK70PGgT740000000000@000?D0ih1e00006JlPC9C3,0*6B
  # That message format isn't friendly at all, but seems very rare so not really great decoding expected for now
  defp parse_message(
         message_id,
         payload
       )
       when message_id == 26 do
    <<repeat_indicator::2, user_id::30, destination_indicator::1, binary_data_flag::1,
      bindata::bitstring>> = payload

    msg = %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      destination_indicator: destination_indicator,
      binary_data_flag: binary_data_flag
    }

    # Add destination_id and spare if destination_indicator == 0 else ignore it
    {msg, bindata} =
      if destination_indicator == 1 do
        <<destination_id::30, spare::2, bindat::bitstring>> = bindata
        {Map.merge(msg, %{destination_id: destination_id, spare: spare}), bindat}
      else
        {msg, bindata}
      end

    {msg, bindata} =
      if destination_indicator == 0 do
        # broadcast
        <<binary_data::104, bindat::bitstring>> = bindata
        {Map.merge(msg, %{binary_data: binary_data}), bindat}
      else
        # addressed
        <<binary_data::72, bindat::bitstring>> = bindata
        {Map.merge(msg, %{binary_data: binary_data}), bindat}
      end

    bin_size = bit_size(bindata) - 20
    <<binary_datas::size(bin_size), radio_status::20>> = bindata
    Map.merge(msg, %{binary_data: binary_datas, radio_status: radio_status})
  end

  # LONG-RANGE AUTOMATIC IDENTIFCATION SYSTEM BROADCAST MESSAGE (MESSAGE 27)
  # https://www.navcen.uscg.gov/?pageName=AISMessage27
  # !AIVDM,1,1,,A,KCQ9r=hrFUnH7P00,0*41
  defp parse_message(
         message_id,
         payload
       )
       when message_id == 27 do
    <<repeat_indicator::2, user_id::30, position_accuracy::1, raim_flag::1,
      navigational_status::4, longitude::integer-signed-size(18),
      latitude::integer-signed-size(17), sog::6, cog::9, position_latency::1, spare::1>> = payload

    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      position_accuracy: position_accuracy,
      raim_flag: raim_flag,
      navigational_status: navigational_status,
      longitude: longitude / 600.0,
      latitude: latitude / 600.0,
      sog: sog,
      cog: cog,
      position_latency: position_latency,
      spare: spare
    }
  end

  # Message 28 to 63 are reserved for future use
  # 45 appeared in the NMEA sample
  defp parse_message(message_id, _payload) when message_id in 28..63 do
    %{}
  end
end
