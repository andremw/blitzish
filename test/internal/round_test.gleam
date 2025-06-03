import gleam/dict
import gleam/list
import gleam/result
import gleeunit
import internal/card

import gleeunit/should

import internal/round.{Player}

pub fn main() {
  gleeunit.main()
}

pub fn all_players_start_round_with_minus_20_points_test() {
  let player1 = Player(card.First)
  let player2 = Player(card.Second)
  let player3 = Player(card.Third)
  let player4 = Player(card.Fourth)

  let points =
    round.new(player1, player2, player3, player4) |> round.calculate_points()

  [player1, player2, player3, player4]
  |> list.map(dict.get(points, _))
  |> result.all
  |> should.equal(Ok([-20, -20, -20, -20]))
}
// I'm wondering how I'm going to test this without cheating or creating a super complex test structure...
// since the Deck is random, non-deterministic, I would need to write an "auto-play" module that plays the game,
// making the moves for all players. that's because a single player might get stuck, without being able to
// place a single card, because even after turning all hand cards and stacking them on the side pile they might still
// not be able to find a card with number 1 (the one that starts the color tower). that's why all players need to be making
// moves so the game can progress and eventually end.

// pub fn a_round_ends_when_a_player_has_75_points_or_more_test() {
//   todo
// }

// pub fn a_player_can_move_a_card_from_the_table_to_the_color_tower_test() {
//   todo
// }

// pub fn a_player_can_move_a_card_from_the_table_to_the_side_pile_test() {
//   todo
// }

// from side pile to side pile
// pub fn a_player_can_move_a_card_from_the_side_pile_to_the_side_pile_test() {
//   todo
// }

// from side pile to color tower
// pub fn a_player_can_move_a_card_from_the_side_pile_to_the_color_tower_test() {
//   todo
// }

// from main pile to side pile
// pub fn a_player_can_move_a_card_from_the_main_pile_to_the_side_pile_test() {
//   todo
// }

// from main pile to color tower
// pub fn a_player_can_move_a_card_from_the_main_pile_to_the_color_tower_test() {
//   todo
// }
