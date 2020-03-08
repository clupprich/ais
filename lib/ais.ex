defmodule AIS do
  def new do
    Agent.start_link(fn -> [] end)
  end

  def parse(pid, string) do
    {parse_state, sentence} = NMEA.parse(string)

    cond do
      parse_state == :invalid_checksum ->
        {parse_state, sentence}

      sentence[:total] == "1" ->
        {state, attributes} = AIS.Payload.parse(sentence.payload)
        sentence = Map.merge(attributes, sentence)

        {state, sentence}

      sentence[:total] == sentence[:current] ->
        [first_sentence | _tail] = Agent.get(pid, fn list -> list end)

        {_, sentence} =
          Map.get_and_update(sentence, :payload, fn payload ->
            {payload, first_sentence.payload <> payload}
          end)

        {state, attributes} = AIS.Payload.parse(sentence.payload)
        sentence = Map.merge(attributes, sentence)

        {state, sentence}

      true ->
        Agent.update(pid, fn list -> [sentence | list] end)
        {:incomplete, sentence}
    end
  end

  def get(pid) do
    Agent.get(pid, fn list -> list end)
  end
end
