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

    test "matches a title with numbers" do
      header = "12 Angry Men"
      {%Article{title: title},  _} = HeaderParser.parse_optional {%Article{}, header}, :title
      assert title == "12 Angry Men"
    end

    test "matches one-character titles" do
      header = "A"
      {%Article{title: title},  _} = HeaderParser.parse_optional {%Article{}, header}, :title
      assert title == "A"
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

    test "returns nil if no author is included" do
      header = "Some Title\n<no@author.com>"
      {%Article{author: author},  _} = HeaderParser.parse_optional {%Article{}, header}, :author
      assert author == nil
    end
  end

  describe "parsing the author email" do
    test "parses the author's email", context do
      {%Article{email: author_email},  _} = HeaderParser.parse_optional {%Article{}, context[:header]}, :email
      assert author_email == "julian@blaustein.com"
    end

    test "returns nil if no author email is included" do
      header = "Some Title\nby Author Minn\n"
      {%Article{email: email},  _} = HeaderParser.parse_optional {%Article{}, header}, :email
      assert email == nil
    end
  end

  describe "parsing topics" do
    test "parses the article topics", context do
      {%Article{topics: topics},  _} = HeaderParser.parse_topics {%Article{}, context[:header]}
      assert topics == ["Films", "Sci-Fi", "Classic"]
    end

    test "returns no topics if not present" do
      {%Article{topics: topics},  _} = HeaderParser.parse_topics {%Article{}, ""}
      assert topics == []
    end
  end

  describe "parsing datetimes" do
    test "parses the created_at time", context do
      {%Article{created_at: created_at},  _} = HeaderParser.parse_datetime {%Article{}, context[:header]}, :created_at

      assert created_at == %DateTime{
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

    test "returns nil if created_at is not present" do
      {%Article{created_at: created_at},  _} = HeaderParser.parse_datetime {%Article{}, ""}, :created_at
      assert created_at == created_at
    end

    test "parses the published_at time", context do
      {%Article{published_at: published_at},  _} = HeaderParser.parse_datetime {%Article{}, context[:header]}, :published_at

      assert published_at == %DateTime{
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

    test "returns nil if published_at is not present" do
      {%Article{published_at: published_at},  _} = HeaderParser.parse_datetime {%Article{}, ""}, :published_at
      assert published_at == published_at
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

    test "returns nil if no summary is present" do
      {%Article{summary: summary},  _} = HeaderParser.parse_optional {%Article{}, ""}, :summary
      assert summary == nil
    end
  end
end
