defmodule MetadataParserTest do
  use ExUnit.Case
  alias Archivist.Parsers.MetadataParser
  alias Archivist.Metadata

  setup do
    {:ok, header} = "test/support/mock_header.arc"
      |> Path.relative_to_cwd
      |> File.read

    [header: header]
  end

  test "parses the title", context do
    {%Metadata{title: title},  _} = MetadataParser.parse_title {%Metadata{}, context[:header]}
    assert title == "The Day the Earth Stood Still"
  end

  test "parses the slug", context do
    {%Metadata{slug: slug},  _} = MetadataParser.parse_slug {%Metadata{}, context[:header]}
    assert slug == "the-day-the-earth-stood-still"
  end

  test "parses the author", context do
    {%Metadata{author: author},  _} = MetadataParser.parse_author {%Metadata{}, context[:header]}
    assert author == "Mike Zazaian"
  end

  test "parses the author's email", context do
    {%Metadata{author_email: author_email},  _} = MetadataParser.parse_author_email {%Metadata{}, context[:header]}
    assert author_email == "mike@functionhaus.com"
  end

end
