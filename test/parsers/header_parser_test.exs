defmodule HeaderParserTest do
  use ExUnit.Case
  alias Arcdown.Parsers.HeaderParser
  alias Arcdown.Article

  setup do
    {:ok, header} = "test/support/header.ad"
      |> Path.relative_to_cwd
      |> File.read

    [header: header]
  end

  test "parses the title", context do
    {%Article{title: title},  _} = HeaderParser.parse_required {%Article{}, context[:header]}, :title
    assert title == "The Day the Earth Stood Still"
  end

  test "parses the slug", context do
    {%Article{slug: slug},  _} = HeaderParser.parse_optional {%Article{}, context[:header]}, :slug
    assert slug == "the-day-the-earth-stood-still"
  end

  test "parses the author", context do
    {%Article{author: author},  _} = HeaderParser.parse_optional {%Article{}, context[:header]}, :author
    assert author == "Julian Blaustein"
  end

  test "parses the author's email", context do
    {%Article{email: author_email},  _} = HeaderParser.parse_optional {%Article{}, context[:header]}, :email
    assert author_email == "julian@blaustein.com"
  end

  test "parses the article tags", context do
    {%Article{tags: tags},  _} = HeaderParser.parse_tags{%Article{}, context[:header]}
    assert tags == [:sci_fi, :horror, :thrillers, :aliens]
  end
end
