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

  @typedoc """
  A programming language with its own preprocessing options.
  """
  @type t :: module

  @doc """
  Retrieve the config for this language.
  """
  @callback config() :: Lichen.Language.Config.t()
end
