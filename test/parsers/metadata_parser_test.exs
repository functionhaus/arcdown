defmodule MetadataParserTest do
  use ExUnit.Case
  alias Archivist.Parsers.MetadataParser
  alias Archivist.Metadata

  test "parse raw attributes" do
    parsed = MetadataParser.parse_raw("title: The title\n author: Dave Thomas\n")
    assert parsed == %Metadata{
      title: "The title",
      author: "Dave Thomas"
    }
  end
end
