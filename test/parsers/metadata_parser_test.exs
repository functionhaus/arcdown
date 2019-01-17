defmodule MetadataParserTest do
  use ExUnit.Case
  alias Arcdown.Parsers.MetadataParser
  alias Arcdown.Metadata

  setup do
    {:ok, header} = "test/support/articles/complete.ad"
      |> Path.relative_to_cwd
      |> File.read

    [header: header]
  end

  test "parses the title", context do
    {%Metadata{title: title},  _} = MetadataParser.parse_title {%Metadata{}, context[:header]}
    assert title == "The Day the Earth Stood Still"
  end

  test "parses the slug", context do
    {%Metadata{slug: slug},  _} = MetadataParser.parse_optional {%Metadata{}, context[:header]}, :slug
    assert slug == "the-day-the-earth-stood-still"
  end

  test "parses the author", context do
    {%Metadata{author: author},  _} = MetadataParser.parse_optional {%Metadata{}, context[:header]}, :author
    assert author == "Mike Zazaian"
  end

  test "parses the author's email", context do
    {%Metadata{email: author_email},  _} = MetadataParser.parse_optional {%Metadata{}, context[:header]}, :email
    assert author_email == "mike@functionhaus.com"
  end

end
