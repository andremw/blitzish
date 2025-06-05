import internal/card.{type DeckDesign, First, Fourth, Second, Third}
import qcheck.{type Generator}

pub fn number() -> Generator(Int) {
  qcheck.bounded_int(1, 10)
}

pub fn design() -> Generator(DeckDesign) {
  qcheck.from_generators(qcheck.constant(First), [
    qcheck.constant(Second),
    qcheck.constant(Third),
    qcheck.constant(Fourth),
  ])
}
