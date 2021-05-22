defmodule Lichen.Preprocessing do
  @moduledoc """
  A module in charge of preprocessing text before passing it to the fingerprinting algorithm.
  """

  alias Lichen.Language

  @identifier "i"

  @doc """
  Preprocesses the string by removing comments, splitting on whitespace
  and special characters into a series of tokens, and renaming all
  generic (non-keyword) identifiers.

  ## Examples

      iex> str = "List<Character> myList = List.of('A', 'B', 'C');"
      ...> Lichen.Preprocessor.preprocess(str, Lichen.Language.Java)
      "List<Character>i=List.i('i','i','i');"

  """
  @spec preprocess(String.t(), Lichen.Language.t()) :: String.t()
  def preprocess(str, language) when is_atom(language) do
    config = language.config()

    str
    |> remove_comments(config)
    |> to_tokens(config)
    |> Enum.flat_map(&String.split/1)
    |> Enum.map(&String.trim/1)
    |> rename_identifiers(config)
    |> Enum.join()
  end

  defp remove_comments(str, %Language.Config{comments: %{open: open, close: close, line: line}}) do
    Enum.zip(
      Enum.map(open, &Regex.escape(&1)),
      Enum.map(close, &Regex.escape/1)
    )
    |> Enum.map(fn {open, close} -> ~r/#{open}.+?#{close}/s end)
    |> Enum.concat(Enum.map(line, &~r/#{Regex.escape(&1)}.+$/m))
    |> Enum.reduce(str, &Regex.replace(&1, &2, ""))
  end

  defp to_tokens(str, config, acc \\ "")
  defp to_tokens("", %Language.Config{} = _config, ""), do: []
  defp to_tokens("", %Language.Config{} = _config, acc), do: [acc]

  defp to_tokens(str, %Language.Config{} = config, acc) do
    {char, next} = String.next_grapheme(str)

    if char in config.special_chars do
      [acc, char | to_tokens(next, config)]
    else
      to_tokens(next, config, acc <> char)
    end
  end

  defp rename_identifiers(tokens, %Language.Config{keywords: keywords, special_chars: sp_chars}) do
    Enum.map(tokens, fn token ->
      if Integer.parse(token) != :error or token in keywords or token in sp_chars,
        do: token,
        else: @identifier
    end)
  end
end
