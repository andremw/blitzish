import internal/card.{type Card}

pub type SideStack {
  /// A stack of cards, used by each player to
  SideStack(cards: List(Card))
}

pub type Deck

pub type ShuffledDeck

pub type Player

pub type Game {
  Game(players: List(Player))
}
