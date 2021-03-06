defmodule ArticleParserTest do
  use ExUnit.Case
  alias Arcdown.Article
  alias Arcdown.Parsers.ArticleParser

  setup do
    content = """
    The Day the Earth Stood Still (a.k.a. Farewell to the Master and Journey to the
    World) is a 1951 American black-and-white science fiction film from 20th Century
    Fox, produced by Julian Blaustein and directed by Robert Wise.
    """

    # expected parsed values:
    {:ok, created_at, _} = DateTime.from_iso8601("2019-01-20T22:24:00Z")
    {:ok, published_at, _} = DateTime.from_iso8601("2019-04-02T04:30:00Z")

    [
      content: content,
      created_at: created_at,
      published_at: published_at
    ]
  end

  test "read/parse a full arcdown text from an .ad file", context do
    {:ok, parsed} = ArticleParser.parse_file "test/support/articles/complete.ad"

    assert parsed == \
      %Article{
        title: "The Day the Earth Stood Still",
        slug: "the-day-the-earth-stood-still",
        author: "Julian Blaustein",
        email: "julian@blaustein.com",
        topics: ["Films", "Sci-Fi", "Classic"],
        created_at: context[:created_at],
        published_at: context[:published_at],
        tags: [:sci_fi, :horror, :thrillers, :aliens],
        summary: "A sci-fi classic about a flying saucer landing in Washington, D.C.",
        content: context[:content]
      }
  end

  test "read/parse a content-only .ad file", context do
    {:ok, parsed} = ArticleParser.parse_file "test/support/articles/content_only.ad"

    assert parsed == \
      %Article{
        content: context[:content]
      }
  end

  test "read/parse a header-only .ad file", context do
    {:ok, parsed} = ArticleParser.parse_file "test/support/articles/header_only.ad"

    assert parsed == \
      %Article{
        title: "The Day the Earth Stood Still",
        slug: "the-day-the-earth-stood-still",
        author: "Julian Blaustein",
        email: "julian@blaustein.com",
        topics: ["Films", "Sci-Fi", "Classic"],
        created_at: context[:created_at],
        published_at: context[:published_at],
        tags: [:sci_fi, :horror, :thrillers, :aliens],
        summary: "A sci-fi classic about a flying saucer landing in Washington, D.C.",
        content: nil
      }
  end

  test "read/parse a whitespace-only .ad file" do
    {:ok, parsed} = ArticleParser.parse_file "test/support/articles/whitespace_only.ad"
    assert parsed == %Article{}
  end

  test "read/parse an empty .ad file" do
    {:ok, parsed} = ArticleParser.parse_file "test/support/articles/empty.ad"
    assert parsed == %Article{}
  end

  describe ".match_parts" do
    test "parsing text that has only content" do
      {:ok, file_text} = "test/support/articles/content_only.ad"
        |> Path.relative_to_cwd
        |> File.read

      {:ok, header, content} = ArticleParser.match_parts file_text

      assert header == nil
      assert content != nil
    end

    test "parsing text that has only a header" do
      {:ok, file_text} = "test/support/articles/header_only.ad"
        |> Path.relative_to_cwd
        |> File.read

      {:ok, header, content} = ArticleParser.match_parts file_text

      assert header != nil
      assert content == nil
    end

    test "parsing an empty string" do
      {:ok, header, content} = ArticleParser.match_parts ""

      assert header == nil
      assert content == nil
    end

    test "parsing a string with only whitespace and newlines" do
      {:ok, header, content} = ArticleParser.match_parts "\n\n\n   \n\n\n"

      assert header == nil
      assert content == nil
    end
  end
end
