import gleam/result
import gleeunit

import internal/deck.{Card}
import internal/hand_pile

import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn turns_one_card_if_one_card_test() {
  let card = Card(color: deck.Blue, number: 1, deck_design: deck.First)

  let assert Ok(#(hand, table)) =
    [card]
    |> hand_pile.new
    |> result.map(hand_pile.turn)
    |> result.map(hand_pile.to_list)

  #(hand, table)
  |> should.equal(#([], [card]))
}

pub fn turns_two_cards_at_once_if_two_cards_test() {
  let card1 = Card(color: deck.Blue, number: 1, deck_design: deck.First)
  let card2 = Card(color: deck.Blue, number: 2, deck_design: deck.First)

  let assert Ok(#(hand, table)) =
    [card1, card2]
    |> hand_pile.new
    |> result.map(hand_pile.turn)
    |> result.map(hand_pile.to_list)

  #(hand, table)
  |> should.equal(#([], [card2, card1]))
}

pub fn turns_three_hand_cards_at_once_if_three_cards_or_more_test() {
  let card1 = Card(color: deck.Blue, number: 1, deck_design: deck.First)
  let card2 = Card(color: deck.Blue, number: 2, deck_design: deck.First)
  let card3 = Card(color: deck.Blue, number: 3, deck_design: deck.First)

  let assert Ok(#(hand, table)) =
    [card1, card2, card3]
    |> hand_pile.new
    |> result.map(hand_pile.turn)
    |> result.map(hand_pile.to_list)

  #(hand, table)
  |> should.equal(#([], [card3, card2, card1]))
}

pub fn turn_moves_table_cards_back_to_hand_when_all_on_table_test() {
  let card = Card(color: deck.Blue, number: 1, deck_design: deck.First)

  let assert Ok(#(hand, table)) =
    [card]
    |> hand_pile.new
    // we turn it once, so now all cards are on the table
    |> result.map(hand_pile.turn)
    // turn again, all cards are back to the hand
    |> result.map(hand_pile.turn)
    |> result.map(hand_pile.to_list)

  #(hand, table)
  |> should.equal(#([card], []))
}
// pub fn takes_top_table_card_test() {
//   todo
// }

// pub fn does_not_add_card_from_different_deck_design_test() {
//   todo
// }

// pub fn does_not_allow_duplicated_card_test() {
//   todo
// }
