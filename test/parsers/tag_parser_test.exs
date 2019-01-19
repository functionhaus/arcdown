defmodule TagParserTest do
  use ExUnit.Case
  alias Arcdown.Parsers.TagParser
  doctest Arcdown.Parsers.TagParser

  test "extracting raw tags from header" do
    {:ok, tags} = TagParser.from_header "* Some-List\n* Of--tags\n* Great\n"
    assert tags == [:some_list, :of_tags, :great]
  end

  test "parsing a list of raw tags" do
    tags = TagParser.parse_list [["* Some-List"], ["* Of--tags"], ["* Great"]]
    assert tags == [:some_list, :of_tags, :great]
  end

  test "formatting a single tag" do
    assert TagParser.format_tag("* Some-List") == "some_list"
    assert TagParser.format_tag("* Of--tags") == "of_tags"
  end
end
