defmodule Arcdown.Parsers.ArticleParser do
  @moduledoc """
  Module responsible for parsing the entire content and filename of a single
  article file and generating an %Article{} struct populated with all
  relevant attributes and metadata
  """

  alias Arcdown.Article
  alias Arcdown.Parsers.HeaderParser

  @patterns %{
    article: ~r/(?<header>i^.*)\n{2}---\n{2}(?<content>.*$)/,
    divider: ~r/\n{2}---\n{2}/
  }

  @doc """
  Read a full Arcdown article from a given filee path, split the header and
  content, construct an Article with content, and parse the header data.
  """
  @spec parse_file(binary()) :: Article.t()
  def parse_file path do
    {:ok, file_text} = File.read path
    parse_string file_text
  end

  @doc """
  Take in a full Arcdown article as a single string, split the header and
  content, construct an Article with content, and parse the header data.
  """
  @spec parse_string(binary()) :: Article.t()
  def parse_string article_text do
    {:ok, header, content} = split_parts article_text

    HeaderParser.parse_header header, %Article{:content: content}
  end

  @spec split_parts(binary()) :: {atom(), binary(), binary()}
  def split_parts article_text do
    Regex.split @patterns[:divider], article_text, parts: 2
  end
end
