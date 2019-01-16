defmodule Archivist.Metadata do
  @moduledoc """
  Available metadata fields for articles.
  """

  @type t :: %__MODULE__{
    title: String.t(),
    slug: String.t(),
    author: String.t(),
    author_email: String.t(),
    summary: String.t(),
    tags: [atom()],
    created_at: DateTime.t(),
    published_at: DateTime.t()
  }

  defstruct [
    :title,
    :slug,
    :author,
    :author_email,
    :summary,
    :tags,
    :created_at,
    :published_at
  ]

end
