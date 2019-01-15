defmodule Archivist.Parsers.ArticleParser do
  alias Archivist.Article
  alias Archivist.Metadata

  @divider_pattern = ~r/\n---\n\n/

  def from_file(path) do
    path
      |> File.read
      |> split_parts
      |> build_article
  end

  defp split_parts({:ok, file_text}) do
    Regex.split(@divider_pattern, file_text, parts: 2)
  end

  defp build_article({:ok, raw_metadata, raw_content}) do
    {:ok, metadata} = YamlElixir.read_from_string raw_metadata
    {:ok, content, _} = Earmark.as_html raw_content

    for {key, val} <- metadata, into: %Article{content: content}, do
      String.to_atom(key), val
    end
  end
end
