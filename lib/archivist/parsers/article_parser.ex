defmodule Archivist.Parsers.ArticleParser do
  @moduledoc """
  Module responsible for parsing the entire content and filename of a single
  article file and generating an %Article{} struct populated with all
  relevant attributes and metadata
  """

  alias Archivist.Article
  alias Archivist.Parsers.MetadataParser

  @divider_pattern = ~r/\n---\n{1,2}/

  @doc "Take in a filename, split the contents, and build the %Article struct."
  @spec parse_file(binary()) :: Article.t()
  def parse_file path do
    path
      |> File.read
      |> split_parts
      |> build_article
  end

  @doc "Split the metdata and content portions of the target file text."
  @spec split_parts({:ok, binary()}) :: [binary(), binary()]
  defp split_parts {:ok, file_text} do
    Regex.split(@divider_pattern, file_text, parts: 2)
  end


  @doc "Construct a full article from the split metadata and content parts."
  @spec build_article({:ok, binary(), binary()}) :: Article.t()
  defp build_article {:ok, metadata, content} do
    {:ok, parsed_content, _} = content
      |> String.trim
      |> Earmark.as_html

    MetadataParser.parse_raw(metadata)
    |> Enum.into %Article{content: parsed_content}
  end
end
