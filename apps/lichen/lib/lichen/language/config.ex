defmodule Lichen.Language.Config do
  @moduledoc """
  Contains some configuration values that the preprocessor uses to parse
  each language differently.
  """

  @typedoc """
  Configuration for how comments work in the language.
  """
  @type comments_config() :: %{
          open: [String.t()],
          close: [String.t()],
          line: [String.t()]
        }

  @typedoc """
  Configuration for a language. Used by the preprocessor.
  """
  @type t() :: %__MODULE__{
          extension: String.t(),
          comments: comments_config(),
          keywords: [String.t()],
          special_chars: [String.t()]
        }

  @enforce_keys [:extension, :comments, :keywords, :special_chars]
  defstruct [:extension, :comments, :keywords, :special_chars]
end
