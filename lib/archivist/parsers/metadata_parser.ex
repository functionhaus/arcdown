defmodule Archivist.Parsers.MetadataParser do
  alias Archivist.Metadata

  @moduledoc """
  A module for parsing a raw metadata value into YAML, formatting its keys and
  values, and returning a %Metadata{} struct.
  """

  # @datetimes [:created_at, :published_at]

  @doc "Parses a raw metadata string and formats it as a struct"
  @spec parse_raw(binary()) :: Metadata.t()
  def parse_raw(raw_header) do
    {%Metadata{}, raw_header}
      |> parse_title
      |> parse_slug
      |> parse_author
      |> parse_author_email
      |> parse_timestamps
      |> parse_tags
      |> parse_summary
  end

  def parse_title({metadata, header}) do
    title = match_one ~r/^[\w\s]+/, header
    {Map.put(metadata, :title, title), header}
  end

  def parse_slug({metadata, header}) do
    slug = match_one ~r/(?<=\<)[a-z0-9\-]+(?=\>\n)/, header
    {Map.put(metadata, :slug, slug), header}
  end

  def parse_author({metadata, header}) do
    author = match_one ~r/(?<=\nby\ )[\w\s]+/, header
    {Map.put(metadata, :author, author), header}
  end

  def parse_author_email({metadata, header}) do
    author_email = match_one ~r/(?<=\nby\ ).*(?=\>\n)/, header
    {Map.put(metadata, :author_email, author_email), header}
  end

  defp match_one(pattern, string) do
    pattern
      |> Regex.run(string, capture: :first)
      |> List.first
      |> String.trim
  end

  def parse_author(_) do
  end
  def parse_timestamps(_) do
  end
  def parse_tags(_) do
  end
  def parse_summary(_) do
  end

#   @spec atomize_keys({:ok, %{required(String.t()) => String.t()}}) :: %{required(atom()) => String.t()}
#   defp atomize_keys {:ok, parsed_metadata} do
#     Stream.transform parsed_metadata, %{}, fn {key, val}, acc ->
#       new_key = key
#         |> String.downcase
#         |> String.to_atom
#
#       Map.put acc, new_key, val
#     end
#   end
#
#   @spec parse_values({:ok, %{required(atom()) => String.t()}}) :: %{required(atom()) => String.t()}
#   defp parse_values atomized do
#     Enum.reduce atomized, fn {key, val}, acc ->
#       parsed_value = cond do
#         Enum.member? @datetimes, key ->
#           DateTime.from_naive(val, "Etc/UTC")
#         key == :tags ->
#           TagParser.parse_list val
#         true ->
#           val
#       end
#
#
#       Map.put acc, key, parsed_value
#     end
#   end
end
