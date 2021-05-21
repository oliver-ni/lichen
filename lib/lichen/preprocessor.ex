defmodule Lichen.Preprocessor do
  @moduledoc false

  alias Lichen.Language

  @identifier "i"

  @doc """
  Preprocesses the string by removing comments, splitting on whitespace
  and special characters into a series of tokens, and renaming all
  generic (non-keyword) identifiers.
  """
  def preprocess(str, language: %Language.Config{} = config) do
    str
    |> remove_comments(config)
    |> to_tokens(config)
    |> Enum.flat_map(&String.split/1)
    |> Enum.map(&String.trim/1)
    |> rename_identifiers(config)
    |> Enum.join()
  end

  defp remove_comments(str, %Language.Config{comments: comments}) do
    str
    |> (&Regex.replace(~r/#{comments.open}.+?#{comments.close}/s, &1, "")).()
    |> (&Regex.replace(~r/#{comments.line}.+$/m, &1, "")).()
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
