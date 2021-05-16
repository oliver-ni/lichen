defmodule Lichen.Language do
  defmacro __using__([]) do
    quote do
      @behaviour Lichen.Language
      alias Lichen.Language
      alias Lichen.Language.Config
    end
  end

  @type comments_config() :: [
          open: [String.t()],
          close: [String.t()],
          line: [String.t()]
        ]

  @type language_config() :: [
          extension: String.t(),
          comments: comments_config(),
          keywords: [String.t()],
          special_chars: [String.t()]
        ]

  @doc """
  Retrieve the config for this language.
  """
  @callback config() :: language_config()
end
