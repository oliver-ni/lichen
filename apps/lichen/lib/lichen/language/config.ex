defmodule Lichen.Language.Config do
  @moduledoc """
  Contains some configuration values that the preprocessor uses to parse
  each language differently.
  """

  use TypedStruct

  @typedoc """
  Configuration for how comments work in the language.
  """
  @type comments_config() :: %{
          open: [String.t()],
          close: [String.t()],
          line: [String.t()]
        }

  typedstruct do
    @typedoc "Configuration for a language. Used by the preprocessor."
    field :extension, String.t(), enforce: true
    field :comments, comments_config(), enforce: true
    field :keywords, [String.t()], enforce: true
    field :special_chars, [String.t()], enforce: true
  end
end
