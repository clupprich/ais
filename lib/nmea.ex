defmodule Nmea do
  @doc """
  Parses an NMEA sentence and returns a `Keyword`.

  Examples:
  iex> Nmea.parse("!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C")
  [talker: "!AI", formatter: "VDM", current: "1", total: "1", sequential: "", channel: "B", payload: "177KQJ5000G?tO`K>RA1wUbN0TKH", padding: "0", checksum: "5C"]

  iex> Nmea.parse("$GPGLL,5133.81,N,00042.25,W*75")
  [talker: "$GP", formatter: "GLL", latitude: "5133.81", north_south: "N", longitude: "00042.25", east_west: "W", checksum: "75"]
  """
  def parse(string) when is_binary(string) do
    values = String.split(string, ",")
    {talker, formatter} = String.split_at(List.first(values), 3)
    values = Enum.concat([talker, formatter], List.delete_at(values, 0))

    decode(List.first(values), Enum.at(values, 1), values)
  end

  def decode(talker, formatter, values) when talker == "!AI" and formatter == "VDM" do
    keys = [:talker, :formatter, :current, :total, :sequential, :channel, :payload, :padding_checksum]
    checksum(Enum.zip(keys, values), :padding)
  end

  def decode(talker, formatter, values) when talker == "$GP" and formatter == "GLL"  do
    keys = [:talker, :formatter, :latitude, :north_south, :longitude, :east_west_checksum]
    checksum(Enum.zip(keys, values), :east_west)
  end

  @doc """
  Splits the entry with the key `name` of the keyword `list` and adds it to 'list'.
  """
  def checksum(list, name) do
    name_with_checksum = String.to_atom(Atom.to_string(name) <> "_checksum")

    {field_and_checksum, list} = Keyword.pop(list, name_with_checksum)
    [field, checksum] = String.split(field_and_checksum, "*")
    new_list = Keyword.put([checksum: checksum], name, field)
    Keyword.merge(list, new_list)
  end
end
