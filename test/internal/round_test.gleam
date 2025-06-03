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
// pub fn a_round_ends_when_a_player_has_75_points_or_more_test() {
//   todo
// }
