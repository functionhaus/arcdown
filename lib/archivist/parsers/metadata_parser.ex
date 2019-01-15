defmodule Archivist.Parsers.MetadataParser do
  alias Archivist.Metadata
  alias Archivist.Parsers.TagParser
  @moduledoc """
  A module for parsing a raw metadata value into YAML, formatting its keys and
  values, and returning a %Metadata{} struct.
  """

  @datetimes = [:created_at, :published_at]

  @doc """
  Parses a raw metadata string and formats it as a struct"

  ## Examples

     iex> __MODULE__.parse_raw("title: The title\n author: Dave Thomas\n")
     %Metadata{
       title: "The title",
       author: "Dave Thomas"
     }

  """
  @spec parse_raw(binary()) :: Metadata.t()
  def parse_raw(raw_metadata) do
    raw_metadata
      |> YamlElixir.read_from_string
      |> atomize_keys
      |> parse_values
      |> Enum.into %Metadata{}
  end

  @doc "Build a stream for converting map key strings into atoms"
  @spec atomize_keys({:ok, %{required(String.t()) => String.t()}) :: %{required(atom()) => String.t()})
  defp atomize_keys {:ok, parsed_metadata} do
    Stream.flat_map parsed_metadata, fn {key, val} ->
      new_key = key
        |> String.downcase
        |> String.to_atom

      new_key, val
    end
  end

  @doc "Formats special values (datetimes, lists) in the map."
  @spec parse_values({:ok, %{required(atom()) => String.t()}) :: %{required(atom()) => String.t()})
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
