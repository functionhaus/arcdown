defmodule ArcdownTest do
  use ExUnit.Case
  doctest Arcdown

  setup do
    content = """
    The Day the Earth Stood Still (a.k.a. Farewell to the Master and Journey to the
    World) is a 1951 American black-and-white science fiction film from 20th Century
    Fox, produced by Julian Blaustein and directed by Robert Wise.
    """

    # expected parsed values:
    {:ok, created_at, _} = DateTime.from_iso8601("2019-01-20T22:24:00Z")
    {:ok, published_at, _} = DateTime.from_iso8601("2019-04-02T04:30:00Z")

    article = %Arcdown.Article{
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

    [article: article]
  end

  test "read/parse a full arcdown text from an .ad file", context do
    {:ok, parsed} = Arcdown.parse_file "test/support/articles/complete.ad"
    assert parsed == context[:article]
  end

  test "parse a full arcdown text from a string", context do
    {:ok, article_text} = "test/support/articles/complete.ad"
      |> Path.relative_to_cwd
      |> File.read

    {:ok, parsed} = Arcdown.parse article_text
    assert parsed == context[:article]
  end
end
