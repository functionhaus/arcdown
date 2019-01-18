defmodule HeaderParserTest do
  use ExUnit.Case
  alias Arcdown.Parsers.HeaderParser
  alias Arcdown.Article

  setup do
    {:ok, header} = "test/support/headers/complete.ad"
      |> Path.relative_to_cwd
      |> File.read

    [header: header]
  end

  describe "parsing the title line" do
    test "parsing the title if present", context do
      {%Article{title: title},  _} = HeaderParser.parse_optional {%Article{}, context[:header]}, :title
      assert title == "The Day the Earth Stood Still"
    end

    test "returns no title if empty" do
      {%Article{title: title},  _} = HeaderParser.parse_optional {%Article{}, ""}, :title
      assert title == nil
    end

    test "does not return the slug if title is missing" do
      header = "<this-is-just-a-slug>"
      {%Article{title: title},  _} = HeaderParser.parse_optional {%Article{}, header}, :title
      assert title == nil
    end
  end

  describe "parsing the slug" do
    test "parses the slug", context do
      {%Article{slug: slug},  _} = HeaderParser.parse_optional {%Article{}, context[:header]}, :slug
      assert slug == "the-day-the-earth-stood-still"
    end

    test "parses a missing slug as nil" do
      header = "This Header Has No Slug"
      {%Article{slug: slug},  _} = HeaderParser.parse_optional {%Article{}, header}, :slug
      assert slug == nil
    end

    test "parses a slug even when no title is present" do
      header = "<some-slug>"
      {%Article{slug: slug},  _} = HeaderParser.parse_optional {%Article{}, header}, :slug
      assert slug == "some-slug"
    end
  end

  describe "parsing the author" do
    test "parses the author", context do
      {%Article{author: author},  _} = HeaderParser.parse_optional {%Article{}, context[:header]}, :author
      assert author == "Julian Blaustein"
    end

    test "parses the author's email", context do
      {%Article{email: author_email},  _} = HeaderParser.parse_optional {%Article{}, context[:header]}, :email
      assert author_email == "julian@blaustein.com"
    end
  end

  describe "parsing topics" do
    test "parses the article topics", context do
      {%Article{topics: topics},  _} = HeaderParser.parse_topics{%Article{}, context[:header]}
      assert topics == ["Films", "Sci-Fi", "Classic"]
    end

    test "returns no topics if not present" do
      {%Article{topics: topics},  _} = HeaderParser.parse_topics {%Article{}, ""}
      assert topics == []
    end
  end

  describe "parsing tags" do
    test "parses the article tags", context do
      {%Article{tags: tags},  _} = HeaderParser.parse_tags{%Article{}, context[:header]}
      assert tags == [:sci_fi, :horror, :thrillers, :aliens]
    end

    test "returns an empty list if no tags are present" do
      {%Article{tags: tags},  _} = HeaderParser.parse_tags {%Article{}, ""}
      assert tags == []
    end
  end

  describe "parsing the summary" do
    test "parses the summary", context do
      {%Article{summary: summary},  _} = HeaderParser.parse_optional {%Article{}, context[:header]}, :summary
      assert summary == "A sci-fi classic about a flying saucer landing in Washington, D.C."
    end
  end
end
