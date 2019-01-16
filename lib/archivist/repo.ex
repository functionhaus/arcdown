defmodule Archivist.Repo do
  @moduledoc """
  Module that coordinates the structured parsing and return of assets in the
  articles root directory.
  """

  @repo_path Path.relative_to_cwd "priv/archivist"

  def topic_names do
    @repo_path
    |> File.ls
    |> Enum.filter(&(File.dir? &1))
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
