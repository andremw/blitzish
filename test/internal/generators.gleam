import internal/card.{type DeckDesign}
import qcheck

pub fn deck_design_generator() -> qcheck.Generator(DeckDesign) {
  qcheck.from_generators(qcheck.constant(card.First), [
    qcheck.constant(card.Second),
    qcheck.constant(card.Third),
    qcheck.constant(card.Fourth),
  ])
}
