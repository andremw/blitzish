import gleam/list
import gleeunit
import internal/card.{First}
import internal/deck

import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn creates_shuffled_deck_with_40_cards_test() {
  let new_deck = deck.new(First)

  new_deck |> deck.to_list |> list.length |> should.equal(40)
}
