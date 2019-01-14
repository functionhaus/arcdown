defmodule Archivist do
  @moduledoc """
  Archivist is an opinionated blogging utility for generating article content
  at compile time from version-controlled markdown files.

  Archivist is based on the general approach of Cẩm Huỳnh's great
  [Nabo](https://github.com/qcam/nabo) library with some key differences:

  * Archivist is an *opinionated* piece of software, meaning it makes decisions
  about how your content should be formatted (Markdown) and parsed (Earmark).

  * Archivist allows articles to be organized into *topic* directories. Articles
  within each directory will be organized by the topic under which they're stored.

  * Archivist doesn't bother parsing your article summary as markdown because
  it's usually only a sentence or two, and you can do that on your own.

  * Archivist allows you to store *flexibly-formatted metadata* with each article
  in case you need to store additional data with any article.

  * Archivist adds default attributes for author names and email addresses, as
  well as sorting content by author.

  * Archivist allows you to set a `created_at` and `published_at` timestamps to
  give you greater control over content organization.

  * Archivist allows you to *tag* your articles however you'd like. It can also
  enforce a constrained set of tags at compile-time if desired.
  """

  def articles do
    __MODULE__.Article.all()
  end

  def topics do
    __MODULE__.Topic.all()
  end

  def tags do
    __MODULE__.Tag.all()
  end

  def authors do
    __MODULE__.Author.all()
  end
end
