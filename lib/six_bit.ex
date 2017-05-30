defmodule SixBit do
  @doc """

  Examples:

  iex> SixBit.decode('14eG')
  <<4, 75, 87>>
  """
  def decode(string) when is_binary(string) do
    to_char_list(string)
      |> decode
  end

  def decode(list) when is_list(list) do
    Enum.map(list, &convert/1)
      |> :erlang.list_to_bitstring
  end

  @doc """
  Converts a single character.

  Examples:

  iex> SixBit.convert(0)
  <<16::size(6)>>

  iex> SixBit.convert(1)
  <<17::size(6)>>
  """
  def convert(char) do
    char6bit = if (char - 48) > 40, do: char - 56, else: char - 48
    <<char6bit :: size(6)>>
  end

  @doc """
  Converts a 6bit value to a 8bit ASCII string.

  Examples:
  iex> SixBit.get_string(1584874876404, 42)
  "WDA9674"

  iex> SixBit.get_string(276724096922795722993303089619927040, 120)
  "MT.MITCHELL"
  """
  def get_string(value, length) do
    chunks(<<value::size(length)>>, 6)
      |> Enum.map(&bitstring_to_binary/1)
      |> Enum.map(&get_character/1)
      |> Enum.join
      |> String.replace("@", "")
  end

  @doc """
  Converts a 6bit ASCII character (represented as an integer) to an 8bit ASCII character.

  Examples:
  iex> SixBit.get_character(0)
  "@"

  iex> SixBit.get_character(48)
  "0"

  iex> SixBit.get_character(32)
  " "
  """
  def get_character(bitstring) when is_bitstring(bitstring) do
    value = :binary.decode_unsigned(bitstring)
    get_character(value)
  end

  def get_character(integer) when integer < 32 do
    get_character(integer + 64)
  end

  def get_character(integer) do
    List.to_string([integer])
  end

  defp chunks(binary, n) do
    do_chunks(binary, n, [])
  end

  defp do_chunks(binary, n, acc) when bit_size(binary) <= n do
    Enum.reverse([binary | acc])
  end

  defp do_chunks(binary, n, acc) do
    <<chunk::size(n), rest::bitstring>> = binary
    do_chunks(rest, n, [<<chunk::size(n)>> | acc])
  end

  defp bitstring_to_binary(bitstring) when bit_size(bitstring) == 6 do
    << <<0::2>>::bitstring, bitstring::bitstring >>
  end
end
