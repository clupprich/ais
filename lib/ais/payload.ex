defmodule AIS.Payload do
  def parse(payload) do
    payload = SixBit.decode(payload)

    <<message_id::6, tail::bitstring>> = payload
    attributes = parse_message(message_id, tail)

    Map.merge(%{message_id: message_id}, attributes)
  end

  # Class A AIS Position Report (Messages 1, 2, and 3)
  defp parse_message(message_id, payload)
       when message_id == 1 or message_id == 2 or message_id == 3 do
    <<repeat_indicator::2, user_id::30, navigational_status::4, rate_of_turn::8, sog::10,
      position_accuracy::1, longitude::28, latitude::27, cog::12, true_heading::9, time_stamp::6,
      special_maneuvre_indicator::2, spare::3, raim_flag::1, communication_state::19>> = payload

    %{
      repeat_indicator: repeat_indicator,
      user_id: user_id,
      navigational_status: navigational_status,
      rate_of_turn: rate_of_turn,
      sog: sog,
      position_accuracy: position_accuracy,
      longitude: longitude,
      latitude: latitude,
      cog: cog,
      true_heading: true_heading,
      time_stamp: time_stamp,
      special_maneuvre_indicator: special_maneuvre_indicator,
      spare: spare,
      raim_flag: raim_flag,
      communication_state: communication_state
    }
  end

  # AIS Class A Ship Static And Voyage Related Data (Message 5)
  defp parse_message(message_id, payload) when message_id == 5 do
    <<repeat_indicator::2, user_id::30, ais_version_indicator::2, imo_number::30, call_sign::42,
      name::120, type_of_ship_and_cargo_type::8, dimension_a::9, dimension_b::9, dimension_c::6,
      dimension_d::6, type_of_electronic_position_fixing_device::4, eta::20,
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
      type_of_electronic_position_fixing_device: type_of_electronic_position_fixing_device,
      eta: eta,
      maximum_present_static_draught: maximum_present_static_draught,
      destination: SixBit.get_string(destination, 120),
      dte: dte,
      spare: spare
    }
  end
end
