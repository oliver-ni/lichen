defmodule Lichen.Result do
  use TypedStruct

  typedstruct do
    @typedoc "Comparison results between two source files."

    field :score, integer(), enforce: true
    field :matches, [[{integer(), integer()}]], enforce: true
  end
end
