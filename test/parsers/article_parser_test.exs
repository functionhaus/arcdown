defmodule ArticleParserTest do
  use ExUnit.Case
  alias Arcdown.Article
  alias Arcdown.Parsers.ArticleParser

  test "read/parse arcdown text from an .ad file" do
    {:ok, parsed} = ArticleParser.parse_file "test/support/articles/complete.ad"

    # expected parsed values:
    {:ok, created_at, _} = DateTime.from_iso8601("2019-01-20T22:24:00Z")
    {:ok, published_at, _} = DateTime.from_iso8601("2019-04-02T04:30:00Z")

    content = """
    The Day the Earth Stood Still (a.k.a. Farewell to the Master and Journey to the
    World) is a 1951 American black-and-white science fiction film from 20th Century
    Fox, produced by Julian Blaustein and directed by Robert Wise.
    """

    assert parsed == \
      %Article{
        title: "The Day the Earth Stood Still",
        slug: "the-day-the-earth-stood-still",
        author: "Julian Blaustein",
        email: "julian@blaustein.com",
        topics: ["Films", "Sci-Fi", "Classic"],
        created_at: created_at,
        published_at: published_at,
        tags: [:sci_fi, :horror, :thrillers, :aliens],
        summary: "A sci-fi classic about a flying saucer landing in Washington, D.C.",
        content: content
      }
  end

end
