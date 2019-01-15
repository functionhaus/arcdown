defmodule Archivist.Parsers.TagParser do
  @moduledoc "A module for parsing raw tag lists from a source article."

  @doc """
  Formats and parses a string of tags into an atomized list.

  ##  Examples

      iex> __MODULE__.parse_string " Some-List  Of--tags    Great   "
      [:some_list, :of_tags, :great]

  """
  @spec parse_string(binary()) :: [atom()]
  def parse_list(tag_string) doc
    tag_string
      |> String.trim
      |> String.split ~r/\w+/
      |> Enum.map &(String.replace &1, ~r/-+/, "_")
      |> Enum.map &(String.to_atom &1)
  end
end
