defmodule Arcdown.Parsers.TagParser do
  @moduledoc "A module for parsing raw tag lists from a source article."

  @tag_pattern ~r/\*[\w\s\-]+\n/

  @doc """
  Extracts raw tags from an Arcdown header and converts it into a formatted
  list of atomized tags.
  """
  @spec from_header(binary()) :: [atom()]
  def from_header(header) do
    tags = Regex.scan(@tag_pattern, header)
    {:ok, parse_list(tags)}
  end

  @doc "Parses and formats a list of tags held in a string into an atomized list."
  @spec parse_list([list()]) :: [atom()]
  def parse_list(tags) do
    tags
      |> List.flatten
      |> Stream.map(&(format_tag &1))
      |> Enum.map(&(String.to_atom &1))
  end

  @doc "Formats a single tag."
  @spec format_tag(binary()) :: binary()
  def format_tag(tag) do
    tag
      |> String.replace(~r/^\*[\s]+/, "")
      |> String.trim
      |> String.downcase
      |> String.replace(~r/\-+/, "_")
  end
end
