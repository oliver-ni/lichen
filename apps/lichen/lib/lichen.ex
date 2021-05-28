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
    case language do
      nil -> Lichen.Winnowing.winnow(str)
      _ -> str |> Lichen.Preprocessing.preprocess(language) |> Lichen.Winnowing.winnow()
    end
  end

  @doc """
  Fingerprints and compares two strings of source files. Optionally accepts a base file
  whose fingerprints are excluded from the comparison. Returns results in a list of tuples in
  the format `{num_matched_fingerprints, num_fingerprints}`, one for each file.
  """
  @spec compare([String.t()], Lichen.Language.t(), compare_options()) :: Lichen.Result.t()
  def compare(strings, language, opts \\ [base: nil]) when is_atom(language) do
    base_fingerprints =
      case opts do
        [base: base] when not is_nil(base) -> fingerprint(base, language)
        _ -> []
      end
      |> Enum.map(&elem(&1, 0))
      |> MapSet.new()

    fingerprints = Enum.map(strings, &fingerprint(&1, language))
    lengths = Enum.map(strings, &String.length/1)

    common_fingerprints =
      fingerprints
      |> Enum.map(fn file ->
        file
        |> Enum.map(&elem(&1, 0))
        |> MapSet.new()
      end)
      |> Enum.reduce(&MapSet.intersection/2)
      |> MapSet.difference(base_fingerprints)

    matched_fingerprints =
      fingerprints
      |> Enum.zip(lengths)
      |> Enum.map(fn {file, length} ->
        file
        |> Enum.chunk_every(2, 1, [{nil, length}])
        |> IO.inspect()
        |> Enum.filter(fn [{x, _}, _] -> x in common_fingerprints end)
        |> Enum.sort()
        |> Enum.dedup_by(fn [{x, _}, _] -> x end)
        |> Enum.map(fn [{_, a}, {_, b}] -> {a, b} end)
      end)

    score =
      fingerprints
      |> Enum.map(fn x -> MapSet.size(common_fingerprints) / Enum.count(x) end)
      |> Enum.max()

    %Lichen.Result{
      score: score,
      matches: Enum.zip(matched_fingerprints)
    }
  end

  @type compare_options :: [base: String.t() | nil]
end
