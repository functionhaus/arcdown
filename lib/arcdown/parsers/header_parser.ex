defmodule Arcdown.Parsers.MetadataParser do
  alias Arcdown.Article

  @moduledoc """
  A module for parsing a raw metadata value into YAML, formatting its keys and
  values, and returning a %Metadata{} struct.
  """

  @patterns %{
    title: ~r/(?<title>^[\w\s]+[\w]+)\ ?\<?[a-z0-9\-]*\>?\n/,
    slug: ~r/^[\w\s]+\<(?<slug>[a-z0-9\-]+)\>\n/,
    author: ~r/\nby\ (?<author>[\w\s]+[\w]+)\ ?\<.*\>?\n/,
    email: ~r/\nby\ [\w\s]+\<(?<email>.*)\>\n/,
    created_at: ~r/\nCreated @ (?<time>\d{1,2}:\d{2}[ap]m) on (?<date>\d{1,2}\/\d{2}\/\d{4})\n/,
    published_at: ~r/\nPublished @ (?<time>\d{1,2}:\d{2}[ap]m) on (?<date>\d{1,2}\/\d{2}\/\d{4})\n/,
    date: ~r/(?<month>\d{1,2})\/(?<day>\d{2})\/(?<year>\d{4})$/,
    time: ~r/(?<hour>\d{1,2}):(?<minute>\d{2})(?<meridiem>[ap]m)$/,
    content: ~r/\n{2}---\n{2}(?<content>.*)$/
  }

  @doc "Parses a raw metadata string and formats it as a struct"
  @spec parse_raw(binary()) :: Article.t()
  def parse_raw(article_text) do
    {:ok, header, content} = Regex.split(@divider_pattern, file_text, parts: 2)

    parse_header(header)
    |> Enum.into(%Article{content: parsed_content})

    {%Article{}, header}
      |> parse_required(:title)
      |> parse_optional(:slug)
      |> parse_optional(:author)
      |> parse_optional(:email)
      |> parse_timestamp(:created_at)
      |> parse_timestamp(:published_at)
      |> parse_tags
      |> parse_summary
      |> parse_content
  end

  @doc "Parses a raw metadata string and formats it as a struct"
  @spec parse_raw(binary()) :: Article.t()
  def parse_header(raw_header) do
    {%Article{}, raw_header}
      |> parse_required(:title)
      |> parse_optional(:slug)
      |> parse_optional(:author)
      |> parse_optional(:email)
      |> parse_timestamp(:created_at)
      |> parse_timestamp(:published_at)
      |> parse_tags
      |> parse_summary
      |> parse_content
  end

  def parse_required({metadata, header}) do
    attr_string = Atom.to_string(attr)

    %{^attr_string => captured} = Regex.named_captures @patterns[attr], header
    {Map.put(metadata, attr, captured), header}
  end

  def parse_optional({metadata, header}, attr) do
    attr_string = Atom.to_string(attr)

    case Regex.named_captures(@patterns[attr], header) do
      %{^attr_string => captured} ->
        {Map.put(metadata, attr, captured), header}
      nil ->
        {metadata, header}
    end
  end

  def parse_timestamp({metadata, header}, attr) do
    %{"time" => time, "date" => date} = Regex.named_captures @patterns[attr], header
    {:ok, datetime} = parse_datetime date, time
    {Map.put(metadata, attr, datetime), header}
  end

  def parse_datetime(date) do
    %{"month" => month, "day" => day, "year" => year} = Regex.named_captures @patterns[:date], date
    %{"hour" => hour, "minute" => minute, "meridiem" => meridiem} = Regex.named_captures @patterns[:time], time

    month = :io.fwrite "~9..0f~n", [month]
    day = :io.fwrite "~9..0f~n", [day]

    hour = case meridiem do
      "am" -> hour
      "pm" ->
        {hour, _} = Integer.parse hour
        "#{hour + 12}"
    end
    hour = :io.fwrite "~9..0f~n", [day]

    {:ok, Datetime.from_naive(~n[#{year}-#{month}-#{day} #{hour}:#{minute}:00], "Etc/UTC")}
  end

  def parse_tags(_) do
  end

  def parse_summary(_) do
  end

  def parse_content(_) do
  end
end
