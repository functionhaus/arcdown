defmodule Arcdown.Parsers.ArticleParser do
  @moduledoc """
  Module responsible for parsing the entire content and filename of a single
  article file and generating an %Article{} struct populated with all
  relevant attributes and metadata
  """

  alias Arcdown.Article
  alias Arcdown.Parsers.HeaderParser

  @patterns %{divider: ~r/\n{2}---\n{2}/}

  @doc """
  Read a full Arcdown article from a given filee path, split the header and
  content, construct an Article with content, and parse the header data.
  """
  @spec parse_file(binary()) :: Article.t()
  def parse_file path do
    {:ok, file_text} = File.read path

    case parse_text(file_text) do
      {:ok, parsed_article} -> {:ok, parsed_article}
      _ -> {:error, "Failed to parse article."}
    end
  end

  @doc """
  Take in a full Arcdown article as a single string, split the header and
  content, construct an Article with content, and parse the header data.
  """
  @spec parse_text(binary()) :: Article.t()
  def parse_text arcdown_text do
    {:ok, header, content} = split_parts arcdown_text
    HeaderParser.parse_header header, %Article{content: content}
  end

  @spec split_parts(binary()) :: {atom(), binary(), binary()}
  def split_parts article_text do
    [header, content] = Regex.split @patterns[:divider], article_text, parts: 2
    {:ok, header, content}
  end
end
