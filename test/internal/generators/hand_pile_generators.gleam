import gleam/pair
import internal/generators/deck_generators.{deck}
import internal/hand_pile.{type HandPile}
import qcheck.{type Generator}

pub fn new() -> Generator(HandPile) {
  use deck <- qcheck.map(deck())

  deck
  |> hand_pile.new
  |> pair.first
}
