defmodule Arcdown.Parsers.TagParser do
  @moduledoc "A module for parsing raw tag lists from a source article."

  @tag_pattern ~r/\*[\w\s\-]+\n/

  @doc ~S"""
  Extracts raw tags from an Arcdown header and converts it into a formatted
  list of atomized tags.

  ##  Examples

      iex> TagParser.from_header "* Some-List\n* Of--tags\n* Great\n"
      {:ok, [:some_list, :of_tags, :great]}

  """
  def from_header(header) do
    tags = Regex.scan(@tag_pattern, header)
    {:ok, parse_list(tags)}
  end

  @doc ~S"""
  Parses and formats a list of tags held in a string into an atomized list.

  ##  Examples

      iex> TagParser.parse_list [["* Some-List"], ["* Of--tags"], ["* Great"]]
      [:some_list, :of_tags, :great]

  """
  @spec parse_list([list()]) :: [atom()]
  def parse_list(tags) do
    tags
      |> List.flatten
      |> Stream.map(&(format_tag &1))
      |> Enum.map(&(String.to_atom &1))
  end

  @doc ~S"""
  Formats a single tag.

  ##  Examples

      iex> TagParser.format_tag "* Some-List"
      "some_list"

      iex> TagParser.format_tag "* Of--tags"
      "of_tags"

  """
  @spec format_tag(binary()) :: binary()
  def format_tag(tag) do
    tag
      |> String.replace(~r/^\*[\s]+/, "")
      |> String.trim
      |> String.downcase
      |> String.replace(~r/\-+/, "_")
  end
end
