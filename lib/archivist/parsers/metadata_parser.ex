defmodule Archivist.Parsers.MetadataParser do
  alias Archivist.Metadata

  @moduledoc """
  A module for parsing a raw metadata value into YAML, formatting its keys and
  values, and returning a %Metadata{} struct.
  """

  @patterns %{
    title: ~r/(?<title>^[\w\s]+[\w]+)\ ?\<?[a-z0-9\-]*\>?\n/,
    slug: ~r/^[\w\s]+\<(?<slug>[a-z0-9\-]+)\>\n/,
    author: ~r/\nby\ (?<author>[\w\s]+[\w]+)\ ?\<.*\>?\n/,
    email: ~r/\nby\ [\w\s]+\<(?<email>.*)\>\n/
  }

  # @datetimes [:created_at, :published_at]

  @doc "Parses a raw metadata string and formats it as a struct"
  @spec parse_raw(binary()) :: Metadata.t()
  def parse_raw(raw_header) do
    {%Metadata{}, raw_header}
      |> parse_title
      |> parse_optional(:slug)
      |> parse_optional(:author)
      |> parse_optional(:email)
      |> parse_timestamps
      |> parse_tags
      |> parse_summary
  end

  def parse_title({metadata, header}) do
    %{"title" => title} = Regex.named_captures @patterns[:title], header
    {Map.put(metadata, :title, title), header}
  end

  def parse_optional({metadata, header}, attr) do
    atomized_attr = Atom.to_string(attr)

    case Regex.named_captures(@patterns[attr], header) do
      %{^atomized_attr => captured} ->
        {Map.put(metadata, attr, captured), header}
      nil ->
        {metadata, header}
    end
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
