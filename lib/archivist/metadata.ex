defmodule Archivist.Metadata do
  @moduledoc """
  Available metadata fields for articles.
  """

  @type t :: %__MODULE__{
    title: String.t,
    author: String.t,
    summary: String.t,
    tags: [atom()],
    created_at: DateTime.t,
    published_at: DateTime.t
  }

  defstruct [
    :title,
    :author,
    :summary,
    :tags,
    :created_at,
    :published_at
  ]

end
