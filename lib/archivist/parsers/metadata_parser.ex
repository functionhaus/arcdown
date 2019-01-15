defmodule Archivist.Parsers.MetadataParser do
  alias Archivist.Parsers.TagParser

  @datetimes = [:created_at, :published_at]

  def parse_raw(raw_metadata) do
    raw_metadata
      |> YamlElixir.read_from_string
      |> atomize_keys
      |> parse_values
      |> Enum.into %Metadata{}
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
    for {key, value} <- atomized, into: %{}, fn {key, value} ->
      value = cond do
        Enum.member? @datetimes, key ->
          DateTime.from_naive(value, "Etc/UTC")
        key == :tags ->
          TagParser.parse_list value
        _ ->
          value
      end

      key, value
    end
  end
end
