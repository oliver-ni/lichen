defmodule Lichen do
  @moduledoc """
  An automatic system for determining the similarity of programs. It primarily aims to
  assist computer science teachers combat plagiarism and cheating by cross-checking code
  sources from individual students, but may have other applications as well, such as in
  search engines or autograding code.
  """

  @doc """
  Generates fingerprints for the given source code and language configuration. The returned
  fingerprints can then be compared to assess similarity.
  """
  @spec fingerprint(String.t(), Lichen.Language.t()) :: [integer()]
  def fingerprint(str, language) when is_atom(language) do
    str
    |> Lichen.Preprocessing.preprocess(language)
    |> Lichen.Winnowing.winnow()
  end

  @doc """
  Fingerprints and compares two strings of source files. Optionally accepts a base file
  whose fingerprints are excluded from the comparison. Returns results in a list of tuples in
  the format `{num_matched_fingerprints, num_fingerprints}`, one for each file.
  """
  @spec compare([String.t()], String.t() | nil, Lichen.Language.t()) :: [{integer(), integer()}]
  def compare(strings, base \\ nil, language) when is_atom(language) do
    base_fingerprints =
      case base do
        nil -> []
        _ -> fingerprint(base, language)
      end
      |> MapSet.new()

    fingerprints =
      Enum.map(strings, fn str ->
        str
        |> fingerprint(language)
        |> MapSet.new()
        |> MapSet.difference(base_fingerprints)
      end)

    num_common =
      fingerprints
      |> Enum.reduce(&MapSet.intersection/2)
      |> MapSet.size()

    Enum.map(fingerprints, &{num_common, MapSet.size(&1)})
  end
end
