defmodule Archivist.Article do
  @moduledoc """
  The core datatype for the Archivist system. Articles are parsed and
  populated at compile-time along with their topics, tags and authors.
  """

  @parsed Archivist.Parser.parse_articles()

  @type t :: %__MODULE__{
    title: String.t,
    author: String.t,
    summary: String.t,
    content: String.t,
    topic: String.t,
    tags: [atom()],
    slug: String.t,
    created_at: DateTime.t,
    published_at: DateTime.t
  }

  defstruct [
    :title,
    :author,
    :summary,
    :content,
    :topic,
    :tags,
    :slug,
    :created_at,
    :published_at
  ]

  @doc "Returns a list of all articles."
  @spec all() :: [__MODULE__.t]
  def all, do: @parsed

end
