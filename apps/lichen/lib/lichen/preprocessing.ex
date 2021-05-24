defmodule Lichen.Preprocessing do
  @moduledoc """
  A module in charge of preprocessing text before passing it to the fingerprinting algorithm.
  """

  alias Lichen.Language

  @identifier "i"

  @doc """
  Preprocesses the string by removing comments, splitting on whitespace
  and special characters, and renaming all generic (non-keyword) identifiers,
  into a stream of tuples in the form `{token, start_index}`.

  ## Examples

      iex> str = "List<Character> myList = List.of('A', 'B', 'C');"
      ...> Lichen.Preprocessing.preprocess(str, Lichen.Language.Java)
      [
        {"List", 0},
        {"<", 4},
        {"Character", 5},
        {">", 14},
        {"i", 16},
        {"=", 23},
        {"List", 25},
        {".", 29},
        {"i", 30},
        {"(", 32},
        {"'", 33},
        {"i", 34},
        {"'", 35},
        {",", 36},
        {"'", 38},
        {"i", 39},
        {"'", 40},
        {",", 41},
        {"'", 43},
        {"i", 44},
        {"'", 45},
        {")", 46},
        {";", 47}
      ]
  """
  @spec preprocess(String.t(), Lichen.Language.t()) :: Enumerable.t({String.t(), integer()})
  def preprocess(str, language) when is_atom(language) do
    config = language.config()

    str
    |> remove_comments(config)
    |> to_tokens(config)
    |> with_indexes()
    |> Stream.map(fn {x, i} -> {String.trim(x), i} end)
    |> Stream.reject(fn {x, _} -> x == "" end)
    |> rename_identifiers(config)
    |> Enum.to_list()
  end

  defp remove_comments(str, %Language.Config{} = config) do
    config
    |> Language.comment_regex()
    |> Enum.reduce(
      str,
      &Regex.replace(&1, &2, fn x -> String.duplicate(" ", String.length(x)) end)
    )
  end

  defp to_tokens(str, %Language.Config{} = config) do
    pattern =
      [~S"\s" | config.special_chars |> Enum.map(&Regex.escape/1)]
      |> Enum.join("|")

    Regex.split(~r/(#{pattern})/, str, include_captures: true)
  end

  defp with_indexes(tokens) do
    Stream.transform(tokens, 0, &{[{&1, &2}], &2 + String.length(&1)})
  end

  defp rename_identifiers(tokens, %Language.Config{keywords: keywords, special_chars: sp_chars}) do
    Stream.map(tokens, fn {token, i} ->
      if Integer.parse(token) != :error or token in keywords or token in sp_chars,
        do: {token, i},
        else: {@identifier, i}
    end)
  end
end
