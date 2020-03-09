defmodule NMEA do
  use Bitwise

  @moduledoc """
  Handle the parsing of the NMEA sentence.
  """

  @doc """
  Parses a single NMEA sentence and returns a `Map`.

  ## Examples
      iex> NMEA.parse("!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C")
      {:ok, %{talker: "!AI", formatter: "VDM", total: "1", current: "1", sequential: "", channel: "B", payload: "177KQJ5000G?tO`K>RA1wUbN0TKH", padding: "0", checksum: "5C"}}

      iex> NMEA.parse("$GPGLL,5133.81,N,00042.25,W*75")
      {:ok, %{talker: "$GP", formatter: "GLL", latitude: "5133.81", north_south: "N", longitude: "00042.25", east_west: "W", checksum: "75"}}
  """
  @spec parse(binary) :: {:invalid_checksum, any} | {:ok, any}
  def parse(string) when is_binary(string) do
    values = String.split(string, ",")
    {talker, formatter} = String.split_at(List.first(values), 3)
    values = Enum.concat([talker, formatter], List.delete_at(values, 0))

    {state, decoded} = decode(Enum.at(values, 0), Enum.at(values, 1), values)

    {state, Enum.into(decoded, %{})}
  end

  # Decode !AIVDM and !BSVDM messages
  defp decode(talker, formatter, values)
       when (talker == "!AI" or talker == "!BS") and formatter == "VDM" do
    keys = [
      :talker,
      :formatter,
      :total,
      :current,
      :sequential,
      :channel,
      :payload,
      :padding_checksum
    ]

    decoded = checksum(Enum.zip(keys, values), :padding)
    computed_checksum = calculate_aivdm_checksum(decoded)

    if computed_checksum == decoded[:checksum] do
      {:ok, decoded}
    else
      {:invalid_checksum, decoded}
    end
  end

  # Decode $GPGLL messages
  defp decode(talker, formatter, values) when talker == "$GP" and formatter == "GLL" do
    keys = [:talker, :formatter, :latitude, :north_south, :longitude, :east_west_checksum]

    decoded = checksum(Enum.zip(keys, values), :east_west)
    computed_checksum = calculate_gpgll_checksum(decoded)

    if computed_checksum == decoded[:checksum] do
      {:ok, decoded}
    else
      {:invalid_checksum, decoded}
    end
  end

  # Calculate checksum for !AIVDM / !BSVDM
  defp calculate_aivdm_checksum(list) do
    "#{String.slice(list[:talker], 1..2)}#{list[:formatter]},#{list[:total]},#{list[:current]},#{
      list[:sequential]
    },#{list[:channel]},#{list[:payload]},#{list[:padding]}"
    |> String.to_charlist()
    |> Enum.reduce(0, &bxor/2)
    |> Integer.to_string(16)
    |> String.pad_leading(2, "0")
  end

  # Calculate checksum for $GPGLL
  defp calculate_gpgll_checksum(list) do
    "#{String.slice(list[:talker], 1..2)}#{list[:formatter]},#{list[:latitude]},#{
      list[:north_south]
    },#{list[:longitude]},#{list[:east_west]}"
    |> String.to_charlist()
    |> Enum.reduce(0, &bxor/2)
    |> Integer.to_string(16)
    |> String.pad_leading(2, "0")
  end

  # Splits the entry with the key `name` of the keyword `list` and adds it to 'list'.
  defp checksum(list, name) do
    name_with_checksum = String.to_atom(Atom.to_string(name) <> "_checksum")

    {field_and_checksum, list} = Keyword.pop(list, name_with_checksum)

    [field, checksum] =
      if length(String.split(field_and_checksum, "*")) == 2 do
        String.split(field_and_checksum, "*")
      else
        [field_and_checksum, nil]
      end

    new_list = Keyword.put([checksum: checksum], name, field)
    Keyword.merge(list, new_list)
  end
end
