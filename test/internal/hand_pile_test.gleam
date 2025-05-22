import gleam/pair
import gleam/result
import gleeunit

import internal/deck.{Card}
import internal/hand_pile

import gleeunit/should

pub fn main() {
  gleeunit.main()
}

const card1 = Card(color: deck.Blue, number: 1, deck_design: deck.First)

const card2 = Card(color: deck.Blue, number: 2, deck_design: deck.First)

const card3 = Card(color: deck.Blue, number: 3, deck_design: deck.First)

const card4 = Card(color: deck.Blue, number: 4, deck_design: deck.First)

pub fn turns_one_card_if_one_card_test() {
  let assert Ok(#(hand, table)) =
    [card1]
    |> hand_pile.new
    |> result.map(hand_pile.turn)
    |> result.map(hand_pile.to_list)

  #(hand, table)
  |> should.equal(#([], [card1]))
}

pub fn turns_two_cards_at_once_if_two_cards_test() {
  let assert Ok(#(hand, table)) =
    [card1, card2]
    |> hand_pile.new
    |> result.map(hand_pile.turn)
    |> result.map(hand_pile.to_list)

  #(hand, table)
  |> should.equal(#([], [card1, card2]))
}

pub fn turns_three_hand_cards_at_once_if_three_cards_or_more_test() {
  let assert Ok(#(hand, table)) =
    [card1, card2, card3]
    |> hand_pile.new
    |> result.map(hand_pile.turn)
    |> result.map(hand_pile.to_list)

  #(hand, table)
  |> should.equal(#([], [card1, card2, card3]))
}

pub fn turn_moves_table_cards_back_to_hand_when_all_on_table_test() {
  let assert Ok(#(hand, table)) =
    [card1]
    |> hand_pile.new
    // we turn it once, so now all cards are on the table
    |> result.map(hand_pile.turn)
    // turn again, all cards are back to the hand
    |> result.map(hand_pile.turn)
    |> result.map(hand_pile.to_list)

  #(hand, table)
  |> should.equal(#([card1], []))
}

pub fn plays_top_table_card_test() {
  let assert Ok(#(pile_pair, card_played)) =
    [card1, card2, card3, card4]
    |> hand_pile.new
    |> result.map(hand_pile.turn)
    |> result.try(hand_pile.play_top_card)
    |> result.map(pair.map_first(_, hand_pile.to_list))

  should.equal(card_played, card2)
  should.equal(pile_pair, #([card1], [card3, card4]))
}

pub fn plays_top_table_card_when_all_cards_are_on_table_test() {
  let assert Ok(#(pile_pair, card_played)) =
    [card1, card2, card3]
    |> hand_pile.new
    |> result.map(hand_pile.turn)
    |> result.try(hand_pile.play_top_card)
    |> result.map(pair.map_first(_, hand_pile.to_list))

  should.equal(card_played, card1)
  should.equal(pile_pair, #([], [card2, card3]))
}

pub fn does_not_play_if_all_cards_are_in_hand_test() {
  let play =
    [card1, card2, card3]
    |> hand_pile.new
    |> result.try(hand_pile.play_top_card)

  play |> should.equal(Error(Nil))
}
// pub fn adds_cards_from_a_deck() {
//   todo
// }

// pub fn does_not_allow_duplicated_card_test() {
//   todo
// }
