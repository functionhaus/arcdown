defmodule ArchivistTest do
  use ExUnit.Case
  doctest Archivist

  test "parses the markdown" do
    {:ok, contents} = File.read "test/support/test_article.md"

    [metadata, article] = Regex.split(~r/\n---\n\n/, contents)

    assert YamlElixir.read_from_string metadata == {:ok, %{
      "author_email" => "dave@wilson.com",
      "author_name" => "Dave Wilson",
      "great" => "burger",
      "name" => "waffles",
      "slug" => "this-is-the-slug",
      "summary" => "This is the entire",
      "tags" => "great, some, thing, waffles-please",
      "title" => "The day the earth stood still"
    }}

    assert {:ok, "<p>This is the article</p>\n", _} = Earmark.as_html article
  end
end
