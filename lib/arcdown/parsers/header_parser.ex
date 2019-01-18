defmodule Arcdown.Parsers.HeaderParser do
  alias Arcdown.Article
  alias Arcdown.Parsers.DateTimeParser
  alias Arcdown.Parsers.TagParser

  @moduledoc "Parser module for the header block of a string of Arcdown text."

  @patterns %{
    title: ~r/(?<title>^[\w\s]+[\w]+)\ ?\<?[a-z0-9\-]*\>?\n/,
    slug: ~r/^[\w\s]+\<(?<slug>[a-z0-9\-]+)\>\n/,
    author: ~r/\nby\ (?<author>[\w\s]+[\w]+)\ ?\<.*\>?\n/,
    email: ~r/\nby\ [\w\s]+\<(?<email>.*)\>\n/,
    created_at: ~r/\nCreated @ (?<time>\d{1,2}:\d{2}[ap]m) on (?<date>\d{1,2}\/\d{2}\/\d{4})\n/,
    published_at: ~r/\nPublished @ (?<time>\d{1,2}:\d{2}[ap]m) on (?<date>\d{1,2}\/\d{2}\/\d{4})\n/
  }

  @doc "Parses a raw header string into an Article struct"
  @spec parse_header(binary()) :: Article.t()
  def parse_header(header, article \\ %Article{}) do
    {article, header}
      |> parse_required(:title)
      |> parse_optional(:slug)
      |> parse_optional(:author)
      |> parse_optional(:email)
      |> parse_timestamp(:created_at)
      |> parse_timestamp(:published_at)
      |> parse_tags
      |> parse_summary
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
  @spec parse_timestamp({Article.t(), binary()}, atom()) :: {Article.t(), binary()}
  def parse_timestamp({article, header}, attr) do
    %{"time" => time, "date" => date} = Regex.named_captures @patterns[attr], header
    {:ok, datetime} = DateTimeParser.parse_human_12h date, time
    {Map.put(article, attr, datetime), header}
  end

  @spec parse_tags({Article.t(), binary()}) :: {Article.t(), binary()}
  def parse_tags({article, header}) do
    {:ok, tags} = TagParser.from_header(header)
    {Map.put(article, :tags, tags), header}
  end

  def parse_summary(_) do
  end

  def parse_content(_) do
  end
end
