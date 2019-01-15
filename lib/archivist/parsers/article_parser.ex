defmodule Archivist.Parsers.ArticleParser do
  alias Archivist.Article
  alias Archivist.Parsers.MetadataParser

  @divider_pattern = ~r/\n---\n{1,2}/

  def parse_file path do
    path
      |> File.read
      |> split_parts
      |> build_article
  end

  defp split_parts {:ok, file_text} do
    Regex.split(@divider_pattern, file_text, parts: 2)
  end

  defp build_article {:ok, metadata, content} do
    {:ok, parsed_content, _} = content
      |> String.trim
      |> Earmark.as_html

    MetadataParser.parse_raw(metadata)
    |> Enum.into %Article{content: parsed_content}
  end
end
