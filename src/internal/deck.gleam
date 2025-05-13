pub type Gender {
  Boy
  Girl
}

pub type Card {
  Card(gender: Gender, number: Int)
}

// TODO: make it opaque so the list doesn't leak out of the module
pub type ColorTower {
  /// The tower of cards that every player can add cards to, in ASCENDING order, from 1 to 10.
  ColorTower(cards: List(Card))
}

pub type SideStack {
  /// A stack of cards, used by each player to
  SideStack(cards: List(Card))
}

pub type SideStacks {
  /// The
  SideStacks(stacks: List(SideStack))
}

pub type Deck

pub type ShuffledDeck

pub type Player

pub type Game {
  Game(players: List(Player))
}
