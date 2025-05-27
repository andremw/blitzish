import gleam/list
import gleam/pair
import internal/card.{type Card}
import internal/deck.{type Deck}
import internal/naive_stack.{type NaiveStack}

pub opaque type MainPile {
  MainPile(cards: NaiveStack(Card))
}

pub fn new(deck: Deck) -> #(MainPile, Deck) {
  let #(main_pile, deck) =
    deck
    |> deck.take(10)
    |> pair.map_first(naive_stack.from_list)
    |> pair.map_first(MainPile)

  #(main_pile, deck)
}

pub fn calculate_points_to_deduct(pile: MainPile) {
  { pile.cards |> naive_stack.to_list |> list.length } * 2
}
