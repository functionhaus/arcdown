defmodule DateTimeParserTest do
  use ExUnit.Case
  alias Arcdown.Parsers.DateTimeParser
  doctest Arcdown.Parsers.DateTimeParser

  test "correctly parses a date with pm time" do
    {:ok, parsed, _offset} = DateTimeParser.parse_human_12h("1/20/2019", "10:24pm")
    assert parsed == %DateTime{
        hour: 22,
        minute: 24,
        second: 0,
        month: 1,
        day: 20,
        year: 2019,
        time_zone: "Etc/UTC",
        utc_offset: 0,
        std_offset: 0,
        zone_abbr: "UTC"
      }
  end


  test "correctly parses a date with am time" do
    {:ok, parsed, _offset} = DateTimeParser.parse_human_12h("4/2/2019", "4:30am")
    assert parsed == %DateTime{
        hour: 4,
        minute: 30,
        second: 0,
        month: 4,
        day: 2,
        year: 2019,
        time_zone: "Etc/UTC",
        utc_offset: 0,
        std_offset: 0,
        zone_abbr: "UTC"
      }
  end
end
