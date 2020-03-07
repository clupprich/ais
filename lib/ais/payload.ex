defmodule AIS.Payload do
  def parse(payload) do
    payload = SixBit.decode(payload)

    <<message_id::6, tail::bitstring>> = payload
    attributes = parse_message(message_id, tail)

    Map.merge(%{message_id: message_id}, attributes)
  end

  defp parse_message(message_id, payload)
       when message_id == 1 or message_id == 2 or message_id == 3 do
    <<repeat_indicator::2, user_id::30, navigational_status::4, rate_of_turn::8, sog::10,
      position_acucuracy::1, longitude::28, latitude::27, cog::12, true_heading::9, time_stamp::6,
      special_manoeuvre_indicator::2, spare::3, raim_flag::1, communication_state::19>> = payload

    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      navigational_status: navigational_status,
      rate_of_turn: rate_of_turn,
      sog: sog,
      position_acucuracy: position_acucuracy,
      longitude: longitude,
      latitude: latitude,
      cog: cog,
      true_heading: true_heading,
      time_stamp: time_stamp,
      special_manoeuvre_indicator: special_manoeuvre_indicator,
      spare: spare,
      raim_flag: raim_flag,
      communication_state: communication_state
    }
  end

  # AIS Base Station Report (Message 4) And Coordinated Universal Time And Date Response (Message 11)
  # https://www.navcen.uscg.gov/?pageName=AIS_Base_Station_Report
  # !AIVDM,1,1,,A,402;bFQv@kkLc00Dl4LE52100@J6,0*58
  defp parse_message(message_id, payload) when message_id == 4 or message_id == 11 do
    <<repeat_indicator::2, user_id::30, utc_year::14, utc_month::4, utc_day::5, utc_hour::5, utc_minute::6, utc_second::6, position_accuracy::1, longitude::28, latitude::27,
    type_of_electronic_position_fixing_device::4, transmission_control_for_long_range_broadcast_message::1, spare::9, raim_flag::1, communication_state::19>> = payload

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
      longitude: longitude,
      latitude: latitude,
      type_of_electronic_position_fixing_device: type_of_electronic_position_fixing_device,
      transmission_control_for_long_range_broadcast_message: transmission_control_for_long_range_broadcast_message,
      spare: spare,
      raim_flag: raim_flag,
      communication_state: communication_state
    }
  end

  defp parse_message(message_id, payload) when message_id == 5 do
    <<repeat_indicator::2, user_id::30, ais_version_indicator::2, imo_number::30, call_sign::42,
      name::120, type_of_ship_and_cargo_type::8, dimension_a::9, dimension_b::9, dimension_c::6,
      dimension_d::6, type_of_electronic_position_fixing_devise::4, eta::20,
      maximum_present_static_draught::8, destination::120, dte::1, spare::1,
      _::bitstring>> = payload

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
      type_of_electronic_position_fixing_devise: type_of_electronic_position_fixing_devise,
      eta: eta,
      maximum_present_static_draught: maximum_present_static_draught, # divide by 10
      destination: SixBit.get_string(destination, 120),
      dte: dte,
      spare: spare
    }
  end

  # AIS Binary Addressed Message (Message 6)
  # https://www.navcen.uscg.gov/?pageName=AISMessage6
  # !AIVDM,1,1,,A,6>jCKIkfJjOt>db;q700@20,2*16
  defp parse_message(message_id, payload) when message_id == 6 do
    <<repeat_indicator::2, source_id::30, sequence_number::2, destination_id::30, retransmit_flag::1, spare::1, _::bitstring>> = payload
    # Binary data = max 936 bits
    # TODO: how to handle that ?
    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      sequence_number: sequence_number,
      destination_id: destination_id,
      retransmit_flag: retransmit_flag,
      spare: spare
    }
  end

  # AIS Binary Broadcast Message (Message 8)
  # https://www.navcen.uscg.gov/?pageName=AISMessage8
  # !AIVDM,1,1,,A,83HT5APj2P00000001BQJ@2E0000,0*72
  defp parse_message(message_id, payload) when message_id == 8 do
    <<repeat_indicator::2, source_id::30, spare::2, _::bitstring>> = payload
    # Binary data = max 968 bits
    # TODO: how to handle that ?
    %{
      repeat_indicator: repeat_indicator,
      source_id: source_id,
      spare: spare
    }
  end

  # AIS STANDARD CLASS B EQUIPMENT POSITION REPORT (MESSAGE 18)
  # https://www.navcen.uscg.gov/?pageName=AISMessagesB
  # !AIVDM,1,1,,B,B3HOIj000H08MeW52k4F7wo5oP06,0*42
  defp parse_message(message_id, payload) when message_id == 18 do
    <<repeat_indicator::2, user_id::30, spare1::8, sog::10, position_accuracy::1, longitude::28, latitude::27, cog::12, true_heading::9, time_stamp::6, spare2::2, class_b_unit_flag::1, class_b_display_flag::1, class_b_dsc_flag::1, class_b_message_22_flag::1,
    mode_flag::1, raim_flag::1, communication_state_selector_flag::1, communication_state::19>> = payload

    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      spare1: spare1,
      sog: sog,
      position_accuracy: position_accuracy,
      longitude: longitude,
      latitude: latitude,
      cog: cog,
      true_heading: true_heading,
      time_stamp: time_stamp,
      spare2: spare2,
      class_b_unit_flag: class_b_unit_flag,
      class_b_display_flag: class_b_display_flag,
      class_b_dsc_flag: class_b_dsc_flag,
      class_b_message_22_flag: class_b_message_22_flag,
      mode_flag: mode_flag,
      raim_flag: raim_flag,
      communication_state_selector_flag: communication_state_selector_flag,
      communication_state: communication_state
    }
  end

  # Data link management message
  defp parse_message(message_id, _payload) when message_id == 20 do
    %{} # TODO
  end

  # AIS Aids To Navigation (ATON) Report (Message 21)
  # https://www.navcen.uscg.gov/?pageName=AISMessage21
  # !AIVDM,1,1,,B,E>jCfrv2`0c2h0W:0a2ah@@@@@@004WD>;2<H50hppN000,4*0A
  defp parse_message(message_id, payload) when message_id == 21 do
    <<repeat_indicator::2, id::30, type_of_aids_to_navigation::5, name_of_aids_to_navigation::120, position_accuracy::1, longitude::28, latitude::27, dimension::30, type_of_electronic_position_fixing_device::4,
    time_stamp::6, off_position_indicator::1, aton_status::8, raim_flag::1, virtual_aton_flag::1, assigned_mode_flag::1, spare::1, _::bitstring>> = payload
    # Extra dynamic fields:
    #  Name of Aid-to-Navigation Extension 	0, 6, 12, 18, 24, 30, 36, ... 84
    #  Spare 	0, 2, 4, or 6
    %{
      repeat_indicator: repeat_indicator,
      id: id,
      type_of_aids_to_navigation: type_of_aids_to_navigation,
      name_of_aids_to_navigation: SixBit.get_string(name_of_aids_to_navigation, 120),
      position_accuracy: position_accuracy,
      longitude: longitude,
      latitude: latitude,
      dimension: dimension,
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
end
