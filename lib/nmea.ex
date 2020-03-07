defmodule NMEA do
  use Bitwise

  @doc """
  Parses an NMEA sentence and returns a `Map`.

  Examples:
  iex> NMEA.parse("!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C")
  %{talker: "!AI", formatter: "VDM", total: "1", current: "1", sequential: "", channel: "B", payload: "177KQJ5000G?tO`K>RA1wUbN0TKH", padding: "0", checksum: "5C"}

  iex> NMEA.parse("$GPGLL,5133.81,N,00042.25,W*75")
  %{talker: "$GP", formatter: "GLL", latitude: "5133.81", north_south: "N", longitude: "00042.25", east_west: "W", checksum: "75"}
  """
  def parse(string) when is_binary(string) do
    values = String.split(string, ",")
    {talker, formatter} = String.split_at(List.first(values), 3)
    values = Enum.concat([talker, formatter], List.delete_at(values, 0))

    {state, decoded} = decode(Enum.at(values, 0), Enum.at(values, 1), values)

    {state, Enum.into(decoded, %{})}
  end

  # Decode !AIVDM messages
  def decode(talker, formatter, values) when talker == "!AI" and formatter == "VDM" do
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

    checksum(Enum.zip(keys, values), :padding)
  end

  # Decode $GPGLL messages
  def decode(talker, formatter, values) when talker == "$GP" and formatter == "GLL" do
    keys = [:talker, :formatter, :latitude, :north_south, :longitude, :east_west_checksum]
    checksum(Enum.zip(keys, values), :east_west)
  end

  @doc """
  Calculate the checksum
  """
  def calculate_checksum(list) do
    "#{String.slice(list[:talker], 1..2)}#{list[:formatter]},#{list[:total]},#{list[:current]},#{list[:sequential]},#{list[:channel]},#{list[:payload]},0"
    |> String.to_charlist
    |> Enum.reduce(0, &bxor/2)
    |> Integer.to_string(16)
  end

  @doc """
  Splits the entry with the key `name` of the keyword `list` and adds it to 'list'.
  """
  def checksum(list, name) do
    name_with_checksum = String.to_atom(Atom.to_string(name) <> "_checksum")

    {field_and_checksum, list} = Keyword.pop(list, name_with_checksum)
    [field, checksum] = String.split(field_and_checksum, "*")

    computed_checksum = calculate_checksum(list)
    IO.puts("checksum #{checksum} computed #{computed_checksum}")

    new_list = Keyword.put([checksum: checksum], name, field)
    final_list = Keyword.merge(list, new_list)

    if computed_checksum == checksum do
      {:ok, final_list}
    else
      {:invalid_checksum, final_list}
    end
  end
end
