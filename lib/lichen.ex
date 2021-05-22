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
end
