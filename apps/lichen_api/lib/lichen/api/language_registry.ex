defmodule Lichen.API.LanguageRegistry do
  use Agent

  def start_link(_opts) do
    Agent.start_link(
      fn ->
        %{
          "py" => Lichen.Language.Python,
          "java" => Lichen.Language.Java
        }
      end,
      name: __MODULE__
    )
  end

  def get(ext) do
    Agent.get(__MODULE__, &Map.get(&1, ext))
  end

  def put(language) do
    Agent.update(__MODULE__, &Map.put(&1, language.extension, language))
  end
end
