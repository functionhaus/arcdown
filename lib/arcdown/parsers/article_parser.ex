defmodule Arcdown.Parsers.ArticleParser do
  @moduledoc """
  Module responsible for parsing the entire content and filename of a single
  article file and generating an %Article{} struct populated with all
  relevant attributes and metadata
  """

  alias Arcdown.Article
  alias Arcdown.Parsers.HeaderParser

  @patterns %{
    divider: ~r/\n{2}---\n{2}/,
    empty_file: ~r/^$/,
    whitespace_only: ~r/^[\n\s]*$/,
    divider_only: ~r/^[\n\s]*---[\n\s]*$/,
    content_only: ~r/^---\n\n/,
    header_only: ~r/^(?<header>[\w\d]+.*)(?!=(\n\n---\n{0,2}))$/,
    full_article: ~r/^(?<header>.*)\n{2}---\n{2}(?<content>.*$)/,
    ambiguous: ~r/\n{0,2}---\n{0,2}/
  }

  @doc """
  Read a full Arcdown article from a given filee path, split the header and
  content, construct an Article with content, and parse the header data.
  """
  @spec parse_file(binary()) :: {atom(), Article.t()|binary()}
  def parse_file path do
    {:ok, file_text} = File.read path

    case parse_text file_text do
      {:ok, parsed_article} -> {:ok, parsed_article}
      _ -> {:error, "Failed to parse article text."}
    end
  end

  @doc """
  Take in a full Arcdown article as a single string, split the header and
  content, construct an Article with content, and parse the header data.
  """
  @spec parse_text(binary()) :: {atom(), Article.t()|binary()}
  def parse_text text do
    {:ok, header, content} = match_parts text

    case {header, content} do
      {nil, nil} ->
        {:ok, %Article{}}

      {nil, content} ->
        {:ok, %Article{content: content}}

      {header, nil} ->
        HeaderParser.parse_header header

      {header, content} ->
        HeaderParser.parse_header header, %Article{content: content}
    end
  end

  @spec match_parts(binary()) :: {atom(), binary()|nil, binary()|nil}
  def match_parts text do
    cond do
      Enum.any?([:empty_file, :whitespace_only, :divider_only], &(Regex.match? @patterns[&1], text)) ->
        {:ok, nil, nil}

      Regex.match? @patterns[:content_only], text ->
        {:ok, nil, Regex.replace(@patterns[:content_only], text, "", global: false)}

      Regex.match? @patterns[:header_only], text ->
        %{"header" => header} = Regex.named_captures @patterns[:header_only], text
        {:ok, header, nil}

      Regex.match? @patterns[:divider], text ->
        [header, content] = Regex.split @patterns[:divider], text, parts: 2
        {:ok, header, content}

      Regex.match? @patterns[:ambiguous], text ->
        %{"content" => content, "header" => header} = Regex.named_captures @patterns[:full_article], text
        {:ok, header, content}

      true ->
        {:ok, text, nil}
    end
  end
end
