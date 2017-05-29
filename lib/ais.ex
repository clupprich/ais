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
        {_, sentence} = Keyword.get_and_update(sentence, :payload, fn(payload) -> {payload, first_sentence[:payload] <> payload} end)
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
