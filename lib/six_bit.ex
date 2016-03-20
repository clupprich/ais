defmodule SixBit do
  def decode(string) when is_binary(string) do
    to_char_list(string)
      |> decode
  end

  @doc """

  Examples:

  iex> SixBit.decode('14eG')
  <<4, 75, 87>>
  """
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
end
