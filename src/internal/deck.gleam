pub type Gender {
  Boy
  Girl
}

pub type Color {
  Blue
  Yellow
  Red
  Green
}

pub fn get_gender(color) {
  case color {
    Red | Blue -> Boy
    Green | Yellow -> Girl
  }
}

pub type Card {
  // TODO: remove gender, as its inferred by the color
  Card(gender: Gender, number: Int, color: Color, deck_design: DeckDesign)
}

pub type SideStack {
  /// A stack of cards, used by each player to
  SideStack(cards: List(Card))
}

/// We'll need to think about the possible deck types here.
/// But it's more of a visual thing, not a super important part of the state
pub type DeckDesign {
  First
  Second
  Third
  Fourth
}

pub type Deck

pub type ShuffledDeck

pub type Player

pub type Game {
  Game(players: List(Player))
}
