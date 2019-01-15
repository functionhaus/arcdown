defmodule Archivist.Repo do
  @moduledoc """
  Module that coordinates the structured parsing and return of assets in the
  articles root directory.
  """

  alias Archivist.Article

  @repo_path = Path.relative_to_cwd "priv/archivist"

  @spec repo_path() :: binary()
  def repo_path, do: @repo_path

  @spec all() :: [Article.t()]
  def all, do: @parsed_articles

  def topic_names do
    repo_path
    |> ls
    |> Enum.filter &(File.dir? &1)
  end

  def articles do
  end

  def topics do
  end

  def tags do
  end

  def authors do
  end
end
