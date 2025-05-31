import gleam/list
import gleam/pair
import gleam/result
import gleeunit
import gleeunit/should

import internal/card.{First}
import internal/deck
import internal/main_pile

pub fn main() {
  gleeunit.main()
}

pub fn calculates_points_to_deduct_as_20_when_full_test() {
  deck.new(First)
  |> main_pile.new
  |> pair.first
  |> main_pile.calculate_points_to_deduct()
  |> should.equal(20)
}

pub fn pile_becomes_main_pile_finished_when_last_one_is_taken_test() {
  let pile = deck.new(First) |> main_pile.new |> pair.first

  // playing top cards 10 times results in MainPileFinished
  list.range(1, 10)
  |> list.fold(Ok(pile), fn(pile_result, _) {
    pile_result
    |> result.try(main_pile.play_top_card)
    |> result.map(pair.second)
  })
  |> result.map(main_pile.is_finished)
  |> should.equal(Ok(True))
}
