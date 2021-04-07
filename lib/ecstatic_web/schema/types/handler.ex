defmodule EcstaticWeb.Schema.Types.Handler do
  use Absinthe.Schema.Notation

  object :handler do
    field :url, non_null(:string)
  end

  input_object :handler_definition_input do
    field :url, non_null(:string)
  end
end
