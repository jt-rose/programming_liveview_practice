# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pento.Repo.insert!(%Pento.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Pento.Catalog

products = [
  %{
    name: "Chess",
    description: "The classic strategy game",
    sku: 8_678_090,
    unit_price: 10.00
  },
  %{
    name: "Tic-Tac-Toe",
    description: "The game of Xs and Os",
    sku: 80_678_090,
    unit_price: 5.00
  },
  %{
    name: "Elden Ring",
    description: "Arise, Tarnished",
    sku: 9_999_999,
    unit_price: 70.00
  },
]

Enum.each(products, fn product -> Catalog.create_product(product) end)
