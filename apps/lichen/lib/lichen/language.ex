defmodule Lichen.Language do
  @moduledoc """
  A behaviour module for a language.
  """

  @doc false
  defmacro __using__([]) do
    quote do
      @behaviour Lichen.Language
      alias Lichen.Language
    end
  end

  @doc """
  Returns a list of regex patterns matching comments in the language.
  """
  @spec comment_regex(Lichen.Language.Config.t()) :: [Regex.t()]
  def comment_regex(%Lichen.Language.Config{comments: %{open: open, close: close, line: line}}) do
    (Enum.zip(
       Enum.map(open, &Regex.escape(&1)),
       Enum.map(close, &Regex.escape/1)
     )
     |> Enum.map(fn {open, close} -> ~r/#{open}.+?#{close}/s end)) ++
      Enum.map(line, &~r/#{Regex.escape(&1)}.+$/m)
  end

  @typedoc """
  A programming language with its own preprocessing options.
  """
  @type t :: module

  @doc """
  Retrieve the config for this language.
  """
  @callback config() :: Lichen.Language.Config.t()
end
