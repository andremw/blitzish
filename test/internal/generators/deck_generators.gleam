import internal/deck.{type Deck}
import internal/generators/card.{design}
import qcheck.{type Generator}

pub fn deck() -> Generator(Deck) {
  use design <- qcheck.map(design())

  deck.new(design)
}
