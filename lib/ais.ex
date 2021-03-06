defmodule AIS do
  @moduledoc """
  AIS Parsing module.

  Handle decoding of the payload, and multi-sentence messages.
  """

  @doc """
  Create an agent for the AIS parser.

  Returns a `pid()`.
  """
  @spec new :: {:error, any} | {:ok, pid}
  def new do
    Agent.start_link(fn -> [] end)
  end

  @doc """
  Parses an AIS NMEA sentence and returns a `Map`.

  ## Return
  - `{:ok, map}` if decoding succeeded
  - `{:error, {:invalid, map}}` if decoding cannot succeede
  - `{:error, {:invalid_checksum, map}}` when the calculated checksum doesn't match the one in the `string`
  - `{:error, {:incomplete}}` when it's only part of a multi-sentence message chain

  ## Examples

      iex> ais=AIS.new()
      iex> AIS.parse(ais, "!AIVDM,1,1,,A,H3HOIFTl00000006Gqjhm01p?650,0*4F")
      {:ok, %{call_sign: "FW9205", channel: "A", checksum: "4F", current: "1", dimension_a: 15, dimension_b: 15, dimension_c: 6, dimension_d: 5, formatter: "VDM", message_id: 24, padding: "0", part_number: 1, payload: "H3HOIFTl00000006Gqjhm01p?650", repeat_indicator: 0, sequential: "", spare: 0, talker: "!AI", total: "1", type_of_electronic_position_fixing_device: 0, type_of_ship_and_cargo_type: 52, user_id: 227006810, vendor_id: ""}}
      iex> AIS.parse(ais, "!AIVDM,1,1,,A,13HPIH001P0jw:LCpNqc7gV0D1C,0*58")
      {:error, {:invalid_checksum, %{channel: "A", checksum: "58", current: "1", formatter: "VDM", padding: "0", payload: "13HPIH001P0jw:LCpNqc7gV0D1C", sequential: "", talker: "!AI", total: "1"}}}
      iex> AIS.parse(ais, "!AIVDM,1,1,,A,59N`1sT2<iHtCEAc@00m<>0Hh4lT,0*5E")
      {:error, {:invalid, %{channel: "A", checksum: "5E", current: "1", formatter: "VDM", padding: "0", payload: "59N`1sT2<iHtCEAc@00m<>0Hh4lT", sequential: "", talker: "!AI", total: "1"}}}
  """
  @spec parse(pid(), binary() | String.t()) ::
          {:ok, Map} | {:error, {:invalid_checksum, Map}} | {:error, {:invalid, Map}} | {:error, {:incomplete, Map}}
  def parse(pid, string) do
    {state, sentence} = NMEA.parse(string)

    cond do
      state == :error ->
        {:error, sentence}

      sentence[:total] == "1" ->
        {state, attributes} = AIS.Payload.parse(sentence.payload, sentence.padding)
        sentence = Map.merge(attributes, sentence)

        if state != :ok do
          IO.puts("Cannot decode message: " <> string)
          {:error, {state, sentence}}
        else
          {state, sentence}
        end

      sentence[:total] == sentence[:current] ->
        [first_sentence | _tail] = Agent.get(pid, fn list -> list end)

        {_, sentence} =
          Map.get_and_update(sentence, :payload, fn payload ->
            {payload, first_sentence.payload <> payload}
          end)

        {state, attributes} = AIS.Payload.parse(sentence.payload, sentence.padding)
        sentence = Map.merge(attributes, sentence)

        if state != :ok do
          IO.puts("Cannot decode message: " <> string)
          {:error, {state, sentence}}
        else
          {state, sentence}
        end

      true ->
        Agent.update(pid, fn list -> [sentence | list] end)
        {:error, {:incomplete, sentence}}
    end
  end

  @doc false
  def get(pid) do
    Agent.get(pid, fn list -> list end)
  end
end
