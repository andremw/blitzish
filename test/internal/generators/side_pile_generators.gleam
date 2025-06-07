import internal/generators/deck_generators.{deck}
import internal/side_pile.{type SidePile}
import qcheck.{type Generator}

pub fn empty() -> Generator(SidePile) {
  use deck <- qcheck.map(deck())

  let #(pile, _) = side_pile.new(deck)

  // a SidePile starts with only one card, so we only need to get the top card once to empty it
  let #(_, pile) = pile |> side_pile.get_top_card

  pile
}
