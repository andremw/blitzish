import gleam/list
import gleam/pair
import gleam/result
import gleeunit
import internal/deck

import internal/card.{Card}
import internal/hand_pile.{type HandPile}

import gleeunit/should

pub fn main() {
  gleeunit.main()
}

const card1 = Card(color: card.Blue, number: 1, deck_design: card.First)

const card2 = Card(color: card.Blue, number: 2, deck_design: card.First)

const card3 = Card(color: card.Blue, number: 3, deck_design: card.First)

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
  let turned_pile =
    deck.new(card.Third)
    |> hand_pile.new2
    |> pair.first
    |> hand_pile.turn

  let assert Ok(expected_played_card) =
    turned_pile |> hand_pile.to_list |> pair.second |> list.first

  let assert Ok(#(pile_pair, card_played)) =
    turned_pile
    |> hand_pile.play_top_card
    |> result.map(pair.map_first(_, hand_pile.to_list))

  should.equal(card_played, expected_played_card)

  pile_pair
  |> pair.map_first(list.length)
  |> pair.map_second(list.length)
  |> should.equal(#(24, 2))
}

pub fn plays_top_table_card_when_all_cards_are_on_table_test() {
  let turned_pile =
    deck.new(card.Fourth)
    |> hand_pile.new2
    |> pair.first
    |> turn_all_cards

  let assert Ok(expected_played_card) =
    turned_pile |> hand_pile.to_list |> pair.second |> list.first

  let assert Ok(#(pile_pair, played_card)) =
    turned_pile
    |> hand_pile.play_top_card
    |> result.map(pair.map_first(_, hand_pile.to_list))

  should.equal(played_card, expected_played_card)

  pile_pair
  |> pair.map_first(list.length)
  |> pair.map_second(list.length)
  |> should.equal(#(0, 26))
}

pub fn does_not_play_if_all_cards_are_in_hand_test() {
  let play =
    deck.new(card.First)
    |> hand_pile.new2
    |> pair.first
    |> hand_pile.play_top_card

  play |> should.equal(Error(Nil))
}

// pub fn turns_one_card_if_one_card_test() {
//   let #(hand, table) =
//     deck.new(card.Second)
//     |> hand_pile.new
//     |> pair.first
//     |> hand_pile.turn
//     |> hand_pile.to_list

//   #(hand, table)
//   |> should.equal(#([], [card1]))
// }

// pub fn turns_two_cards_at_once_if_two_cards_test() {
//   let #(hand, table) =
//     deck.new(card.First)
//     |> hand_pile.new
//     |> pair.first
//     |> hand_pile.turn
//     |> hand_pile.to_list

//   #(hand, table)
//   |> should.equal(#([], [card1, card2]))
// }

// pub fn turns_three_hand_cards_at_once_if_three_cards_or_more_test() {
//   let #(hand, table) =
//     deck.new(card.Third)
//     |> hand_pile.new
//     |> pair.first
//     |> hand_pile.turn
//     |> hand_pile.to_list

//   #(hand, table)
//   |> should.equal(#([], [card1, card2, card3]))
// }

// pub fn turn_moves_table_cards_back_to_hand_when_all_on_table_test() {
//   let #(hand, table) =
//     deck.new(card.Third)
//     |> hand_pile.new
//     |> pair.first
//     // we turn it once, so now all cards are on the table
//     |> hand_pile.turn
//     // turn again, all cards are back to the hand
//     |> hand_pile.turn
//     |> hand_pile.to_list

//   #(hand, table)
//   |> should.equal(#([card1], []))
// }

// pub fn adds_cards_from_a_deck() {
//   todo
// }

// pub fn does_not_allow_duplicated_card_test() {
//   todo
// }

fn turn_all_cards(pile: HandPile) {
  let necessary_turns = 27 / 3
  use pile, _ <- list.fold(list.range(1, necessary_turns), pile)
  hand_pile.turn(pile)
}
