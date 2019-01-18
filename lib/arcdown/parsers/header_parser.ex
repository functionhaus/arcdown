defmodule Arcdown.Parsers.HeaderParser do
  alias Arcdown.Article

  @moduledoc """
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

  def parse_required({article, header}) do
    attr_string = Atom.to_string(attr)

    %{^attr_string => captured} = Regex.named_captures @patterns[attr], header
    {Map.put(article, attr, captured), header}
  end

  def parse_optional({article, header}, attr) do
    attr_string = Atom.to_string(attr)

    case Regex.named_captures(@patterns[attr], header) do
      %{^attr_string => captured} ->
        {Map.put(article, attr, captured), header}
      nil ->
        {article, header}
    end
  end

  def parse_timestamp({article, header}, attr) do
    %{"time" => time, "date" => date} = Regex.named_captures @patterns[attr], header
    {:ok, datetime} = parse_datetime date, time
    {Map.put(article, attr, datetime), header}
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
