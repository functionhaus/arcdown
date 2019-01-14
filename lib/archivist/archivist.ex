defmodule Archivist.Article do
  @moduledoc """
  The core datatype for the Archivist system. Articles are parsed and
  populated at compile-time along with their topics, tags and authors.
  """

  @parsed Archivist.Parser.parse_articles()

  defstruct [
    :title,
    :author,
    :summary,
    :content,
    :parsed_content,
    :topic,
    :tags,
    :slug,
    :created_at,
    :published_at
  ]

  @doc "Returns a list of all articles."
  @spec all() :: [%Archivist.Article.t()]
  def all, do: @parsed

end
