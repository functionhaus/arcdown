defmodule Arcdown.Parsers.HeaderParser do
  alias Arcdown.Article
  alias Arcdown.Parsers.DateTimeParser
  alias Arcdown.Parsers.TagParser

  @moduledoc "Parser module for the header block of a string of Arcdown text."

  @patterns %{
    title: ~r/(?<title>^[\w\s\d]*[\w\d]+)\ ?\<?[a-z0-9\-]*\>?(\n|$)/,
    slug: ~r/^[\w\s\d]*\<(?<slug>[a-z0-9\-]+)\>(\n|$)/,
    author: ~r/(\n|^)by\ (?<author>[\w\s\d]*[\w\d]+)\ ?\<.*\>?(\n|$)/,
    email: ~r/(\n|^)by\ [\w\s\d]*\<(?<email>.*\@.*\..*)\>(\n|$)/,
    created_at: ~r/(\n|^)Created @ (?<time>\d{1,2}:\d{2}[ap]m) on (?<date>\d{1,2}\/\d{1,2}\/\d{4})(\n|$)/,
    published_at: ~r/(\n|^)Published @ (?<time>\d{1,2}:\d{2}[ap]m) on (?<date>\d{1,2}\/\d{1,2}\/\d{4})(\n|$)/,
    summary: ~r/(\n|^)Summary:\n(?<summary>.*)$/,
    topics: ~r/(\n|^)Filed under: (?<topics>[\w\s\d->]+)(\n|$)/
  }

  @doc "Parses a raw header string into an Article struct"
  @spec parse_header(binary()) :: Article.t()
  def parse_header(header, article \\ %Article{}) do
    {parsed_article, _} = {article, header}
      |> parse_optional(:title)
      |> parse_optional(:slug)
      |> parse_optional(:author)
      |> parse_optional(:email)
      |> parse_topics
      |> parse_datetime(:created_at)
      |> parse_datetime(:published_at)
      |> parse_tags
      |> parse_optional(:summary)

    {:ok, parsed_article}
  end

  @doc """
  Provide an %Article{} struct, header string, and attribute atom as input,
  expecting the attribute pattern to match text found in the article string.

  Will return an error if no text is found matching the attribute pattern.
  """
  @spec parse_required({Article.t(), binary()}, atom()) :: {Article.t(), binary()}
  def parse_required({article, header}, attr) do
    attr_string = Atom.to_string(attr)

    %{^attr_string => captured} = Regex.named_captures @patterns[attr], header
    {Map.put(article, attr, captured), header}
  end

  @doc """
  Provide an %Article{} struct, header string, and attribute atom as input,
  expecting the attribute pattern to match text found in the article string.

  If no text is found in the header string that matches the pattern for the
  given attribute, the original %Article{} struct will be returned instead.
  """
  @spec parse_optional({Article.t(), binary()}, atom()) :: {Article.t(), binary()}
  def parse_optional({article, header}, attr) do
    attr_string = Atom.to_string(attr)

    case Regex.named_captures(@patterns[attr], header) do
      %{^attr_string => captured} ->
        {Map.put(article, attr, captured), header}
      nil ->
        {article, header}
    end
  end

  @doc """
  Provide an %Article{} struct, header string, and attribute atom as input,
  expecting the attribute pattern to match text found in the article string.

  If no text is found in the header string that matches the pattern for the
  given attribute, the original %Article{} struct will be returned instead.

  Matching patterns are parsed and returned as DateTime structs, and applied
  to the matching attribute name in the %Article{} struct.
  """
  @spec parse_datetime({Article.t(), binary()}, atom()) :: {Article.t(), binary()}
  def parse_datetime({article, header}, attr) do
    case Regex.named_captures @patterns[attr], header do
      %{"time" => time, "date" => date} ->
        {:ok, datetime, _offset} = DateTimeParser.parse_human_12h date, time
        {Map.put(article, attr, datetime), header}
      nil ->
        {article, header}
    end
  end

  @doc """
  Provide an %Article{} struct and header string as input and match any tags
  found, parse them, and return them as a formatted list of atoms.

  If no tags are found in the header string the original %Article{} struct will
  be returned instead.
  """
  @spec parse_tags({Article.t(), binary()}) :: {Article.t(), binary()}
  def parse_tags({article, header}) do
    {:ok, tags} = TagParser.from_header(header)
    {Map.put(article, :tags, tags), header}
  end

  @doc """
  Provide an %Article{} struct and header string as input and match any topics
  found, parse them, and return them as a formatted list of strings.

  If no topics are found in the header string the original %Article{} struct
  will be returned instead.
  """
  @spec parse_topics({Article.t(), binary()}) :: {Article.t(), binary()}
  def parse_topics({article, header}) do
    topics_list = case Regex.named_captures @patterns[:topics], header do
      %{"topics" => topics} ->
        topics
          |> String.split(" > ", trim: true)
          |> Enum.map(&(String.trim &1))

      nil -> []
    end

    {Map.put(article, :topics, topics_list), header}
  end
end
