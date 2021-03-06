defmodule Arcdown.Article do
  @moduledoc """
  The core datatype for the Arcdown parser. Articles are broken into header and
  body/content parts then compiled into the %Arcdown.Article{} struct.
  """

  @type t :: %__MODULE__{
    title: String.t(),
    author: String.t(),
    email: String.t(),
    summary: String.t(),
    content: String.t(),
    topics: [String.t()],
    tags: [atom()],
    slug: String.t(),
    created_at: DateTime.t,
    published_at: DateTime.t
  }

  defstruct [
    :title,
    :author,
    :email,
    :summary,
    :content,
    :topics,
    :tags,
    :slug,
    :created_at,
    :published_at
  ]
end
