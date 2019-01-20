defmodule Arcdown do
  @moduledoc """
  Arcdown is a parsing library for articles written in Arcdown (.ad) format.

  It is written in pure Elixir/Erlang with no additional dependencies when being
  used in production.

  This top-level Arcdown module is mostly populated with a helper interface
  provided for convenience and clarity in implementation.
  """

  alias Arcdown.Parsers.ArticleParser

  @doc """
  Wrapper method for reading an article from a file, then parsing its contents.
  """
  @spec parse_file(binary()) :: {atom(), Article.t()|binary()}
  def parse_file path do
    ArticleParser.parse_file path
  end


  @doc """
  Wrapper method for directly parsing a text from Arcdown format into an object.
  """
  @spec parse(binary()) :: {atom(), Article.t()|binary()}
  def parse text do
    ArticleParser.parse_text text
  end
end
