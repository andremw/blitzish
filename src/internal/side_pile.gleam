import gleam/list
import internal/deck.{type Card}

pub type SidePile {
  SidePile(cards: List(Card))
}

pub fn new() {
  SidePile(cards: [])
}

pub fn place_card(pile: SidePile, card) {
  let cards = pile.cards
  SidePile(list.append(cards, [card]))
}

pub fn get_top_card(pile: SidePile) {
  pile.cards |> list.last
}
