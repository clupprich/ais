defmodule Ais do
  def new do
    Agent.start_link(fn -> [] end)
  end

  def parse(pid, string) do
    sentence = Nmea.parse(string)

    cond do
      sentence[:total] == "1" ->
        {:ok, sentence}

      sentence[:total] == sentence[:current] ->
        [first_sentence|_tail] = Agent.get(pid, fn(list) -> list end)
        {_, sentence} = Map.get_and_update(sentence, :payload, fn(payload) -> {payload, first_sentence.payload <> payload} end)

        payload = SixBit.decode(sentence.payload)
        <<message_id::6, repeat_indicator::2, user_id::30, ais_version_indicator::2, imo_number::30, call_sign::42,
          name::120, type_of_ship_and_cargo_type::8, dimension::30, type_of_electronic_position_fixing_devise::4,
          eta::20, maximum_present_static_draught::8, destination::120, dte::1, spare::1, _::bitstring >> = payload

        call_sign   = SixBit.get_string(call_sign, 42)
        name        = SixBit.get_string(name, 120)
        destination = SixBit.get_string(destination, 120)

        sentence = Map.merge(%{message_id: message_id, repeat_indicator: repeat_indicator, user_id: user_id,
                               ais_version_indicator: ais_version_indicator, imo_number: imo_number,
                               call_sign: call_sign, name: name,
                               type_of_ship_and_cargo_type: type_of_ship_and_cargo_type,
                               type_of_electronic_position_fixing_devise: type_of_electronic_position_fixing_devise,
                               eta: eta, maximum_present_static_draught: maximum_present_static_draught,
                               destination: destination}, sentence)

        {:ok, sentence}

      true ->
        Agent.update(pid, fn(list) -> [sentence|list] end)
        {:incomplete, sentence}
    end
  end

  def get(pid) do
    Agent.get(pid, fn(list) -> list end)
  end
end
