import internal/card.{type DeckDesign}
import internal/deck.{type Deck}
import qcheck

pub fn deck_generator() -> qcheck.Generator(Deck) {
  use design <- qcheck.map(deck_design_generator())

  deck.new(design)
}

fn deck_design_generator() -> qcheck.Generator(DeckDesign) {
  qcheck.from_generators(qcheck.constant(card.First), [
    qcheck.constant(card.Second),
    qcheck.constant(card.Third),
    qcheck.constant(card.Fourth),
  ])
}
