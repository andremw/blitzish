import internal/generators/card.{design}
import internal/round.{type Player, Player}
import qcheck.{type Generator}

pub fn player() -> Generator(Player) {
  use design <- qcheck.map(design())

  Player(design)
}
