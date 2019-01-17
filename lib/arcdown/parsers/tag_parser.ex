defmodule Arcdown.Parsers.TagParser do
  @moduledoc "A module for parsing raw tag lists from a source article."

  @doc """
  Parses and formats a list of tags held in a string into an atomized list.

  ##  Examples

      iex> __MODULE__.parse_list " Some-List  Of--tags    Great   "
      [:some_list, :of_tags, :great]

  """
  @spec parse_list(binary()) :: [atom()]
  def parse_list(tag_string) do
    tag_string
      |> String.trim
      |> String.split(~r/\w+/)
      |> Enum.map(&(String.replace &1, ~r/-+/, "_"))
      |> Enum.map(&(String.to_atom &1))
  end
end
