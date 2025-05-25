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
