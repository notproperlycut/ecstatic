defmodule EcstaticWeb.Schema do
  use Absinthe.Schema

  @desc "An item"
  object :item do
    field :id, :id
    field :name, :string
  end

  # Example data
  @menu_items %{
    "foo" => %{id: 1, name: "Pizza"},
    "bar" => %{id: 2, name: "Burger"},
    "foobar" => %{id: 3, name: "PizzaBurger"}
  }

  query do
    field :menu_item, :item do
      arg :id, non_null(:id)
      resolve fn %{id: item_id}, _ ->
        {:ok, @menu_items[item_id]}
      end
    end
  end

end
