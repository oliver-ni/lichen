defmodule Lichen.Language do
  @moduledoc """
  A behaviour module for a language. Contains some configuration values that
  the preprocessor uses to parse each language differently.
  """

  @doc false
  defmacro __using__([]) do
    quote do
      @behaviour Lichen.Language
      alias Lichen.Language
      alias Lichen.Language.Config
    end
  end

  @doc """
  Retrieve the config for this language.
  """
  @callback config() :: language_config()

  @typedoc """
  Configuration for how comments work in the language.
  """
  @type comments_config() :: [
          open: [String.t()],
          close: [String.t()],
          line: [String.t()]
        ]

  @typedoc """
  Configuration for a language. Used by the preprocessor.
  """
  @type language_config() :: [
          extension: String.t(),
          comments: comments_config(),
          keywords: [String.t()],
          special_chars: [String.t()]
        ]
end
