defmodule Arcdown.Parsers.ArticleParser do
  @moduledoc """
  Module responsible for parsing the entire content and filename of a single
  article file and generating an %Article{} struct populated with all
  relevant attributes and metadata
  """

  alias Arcdown.Article
  alias Arcdown.Parsers.MetadataParser

  @divider_pattern ~r/\n---\n/

  @doc "Take in a filename, split the contents, and build the %Article struct."
  @spec parse_file(binary()) :: Article.t()
  def parse_file path do
    path
      |> File.read
      |> split_parts
      |> build_article
  end

  @spec split_parts({:ok, binary()}) :: {:ok, binary(), binary()}
  defp split_parts {:ok, file_text} do
    Regex.split(@divider_pattern, file_text, parts: 2)
  end


  @spec build_article({:ok, binary(), binary()}) :: Article.t()
  defp build_article {:ok, metadata, content} do
    {:ok, parsed_content, _} = content
      |> String.trim
      |> Earmark.as_html

    MetadataParser.parse_raw(metadata)
    |> Enum.into(%Article{content: parsed_content})
  end
end
