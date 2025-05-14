import gleeunit
import internal/deck.{Card}
import internal/side_pile.{get_top_card, place_card}

import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn places_card_when_empty_test() {
  let card = Card(color: deck.Blue, deck_design: deck.First, number: 5)

  let pile =
    side_pile.new()
    |> place_card(card)

  let assert Ok(top_card) = get_top_card(pile)

  top_card
  |> should.equal(card)
}

pub fn places_descending_card_test() {
  let second_card = Card(color: deck.Blue, deck_design: deck.First, number: 4)
  let pile =
    side_pile.new()
    |> place_card(Card(color: deck.Blue, deck_design: deck.First, number: 5))
    |> place_card(second_card)

  let assert Ok(top_card) = get_top_card(pile)

  top_card
  |> should.equal(second_card)
}
// pub fn does_not_place_ascending_card_test() {
//   todo
// }

// pub fn does_not_place_same_gender_card_test() {
//   todo
// }
