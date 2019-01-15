defmodule Archivist.Parsers.ArticleParser do
  alias Archivist.Article

  @divider_pattern = ~r/\n---\n\n/
  @datetimes = [:created_at, :published_at]

  def from_file path do
    path
      |> File.read
      |> split_parts
      |> build_article
  end

  defp split_parts {:ok, file_text} do
    Regex.split(@divider_pattern, file_text, parts: 2)
  end

  defp build_article {:ok, metadata, content} do
    parsed_metadata = metadata
      |> YamlElixir.read_from_string
      |> atomize_keys
      |> parse_values

    {:ok, parsed_content, _} = Earmark.as_html content

    parsed_metadata
    |> Enum.into %Article{content: parsed_content}
  end

  defp atomize_keys {:ok, parsed_metadata} do
    Stream.flat_map parsed_metadata, fn {key, val} ->
      new_key = key
        |> String.downcase
        |> String.to_atom

      new_key, val
    end
  end

  defp parse_values atomized do
    Enum.map atomized, fn {key, value} ->
      cond do
        Enum.member? @datetimes, key ->
          DateTime.from_naive(value, "Etc/UTC")
        key == :tags ->
          parse_tags value
        _ ->
          value
      end
    end
  end

  defp parse_tags tag_string do
  end
end
