import gleam/result
import gleeunit

import internal/deck.{Card}
import internal/hand_pile

import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// pub fn does_not_accept_more_than_27_cards_test() {
//   todo
// }

// const default_cards = [
//   Card(color: deck.Blue, number: 1, deck_design: deck.First),
//   Card(color: deck.Blue, number: 2, deck_design: deck.Second),
//   Card(color: deck.Blue, number: 3, deck_design: deck.Second),
//   Card(color: deck.Blue, number: 4, deck_design: deck.Second),
//   Card(color: deck.Blue, number: 5, deck_design: deck.Third),
//   Card(color: deck.Blue, number: 6, deck_design: deck.First),
//   Card(color: deck.Blue, number: 7, deck_design: deck.First),
//   Card(color: deck.Blue, number: 8, deck_design: deck.Fourth),
//   Card(color: deck.Blue, number: 9, deck_design: deck.Second),
//   Card(color: deck.Blue, number: 10, deck_design: deck.Second),
// ]

pub fn turns_one_card_if_one_card_test() {
  let card = Card(color: deck.Blue, number: 1, deck_design: deck.First)

  let assert Ok(#(hand, table)) =
    [card]
    |> hand_pile.new
    |> hand_pile.turn
    |> result.map(hand_pile.to_list)

  #(hand, table)
  |> should.equal(#([], [card]))
}
// pub fn turns_two_cards_at_once_if_two_cards_test() {
//   todo
// }

// pub fn turns_three_hand_cards_at_once_if_three_cards_or_more_test() {
//   todo
// }

// pub fn takes_top_table_card_test() {
//   todo
// }

// pub fn does_not_add_card_from_different_deck_design_test() {
//   todo
// }

// pub fn does_not_allow_duplicated_card_test() {
//   todo
// }

// pub fn moves_table_cards_back_to_hand_test() {
//   todo
// }
