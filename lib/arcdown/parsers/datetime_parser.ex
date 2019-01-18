defmodule Arcdown.Parsers.DateTimeParser do
  @moduledoc """
  A module for parsing human-readable date and time formats into native
  Elixir entities.
  """

  @patterns %{
    date: ~r/(?<month>\d{1,2})\/(?<day>\d{2})\/(?<year>\d{4})$/,
    time: ~r/(?<hour>\d{1,2}):(?<minute>\d{2})(?<meridiem>[ap]m)$/
  }

  @spec parse_human_12h(binary(), binary()) :: {:ok, DateTime.t()}
  def parse_human_12h(date, time) do
    %{"month" => month, "day" => day, "year" => year} = Regex.named_captures @patterns[:date], date
    %{"hour" => hour, "minute" => minute, "meridiem" => meridiem} = Regex.named_captures @patterns[:time], time

    hour = case meridiem do
      "am" -> hour
      "pm" ->
        {hour, _} = Integer.parse hour
        "#{hour + 12}"
    end

    hour = :string.pad hour, 2, :leading, "0"
    month = :string.pad month, 2, :leading, "0"
    day = :string.pad day, 2, :leading, "0"

    {:ok, DateTime.from_naive("#{year}-#{month}-#{day} #{hour}:#{minute}:00", "Etc/UTC")}
  end
end
