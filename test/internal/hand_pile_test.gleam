import gleam/list
import gleam/pair
import gleam/result
import gleeunit
import internal/deck

import internal/card
import internal/hand_pile.{type HandPile}

import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn turn_moves_table_cards_back_to_hand_when_all_on_table_test() {
  let turned_pile =
    deck.new(card.Second)
    |> hand_pile.new
    |> pair.first
    |> turn_all_cards

  // turn once more to move all cards to the hand
  let pile_in_hand = turned_pile |> hand_pile.turn

  pile_in_hand
  |> hand_pile.to_list
  |> pair.map_first(list.length)
  |> pair.map_second(list.length)
  |> should.equal(#(27, 0))
}

pub fn plays_top_table_card_test() {
  let turned_pile =
    deck.new(card.Third)
    |> hand_pile.new
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
    |> hand_pile.new
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
    |> hand_pile.new
    |> pair.first
    |> hand_pile.play_top_card

  play |> should.equal(Error(Nil))
}

// pub fn does_not_allow_duplicated_card_test() {
//   todo
// }

fn turn_all_cards(pile: HandPile) {
  let necessary_turns = 27 / 3
  use pile, _ <- list.fold(list.range(1, necessary_turns), pile)
  hand_pile.turn(pile)
}
