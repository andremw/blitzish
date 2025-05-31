import gleam/pair
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
// pub fn takes_top_card_if_it_is_one_test() {
//   todo
// }

// pub fn takes_no_card_if_it_is_not_one_test() {
//   todo
// }

// pub fn returns_finished_pile_when_last_one_is_taken_test() {
//   todo
// }
