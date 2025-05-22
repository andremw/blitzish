import gleam/list
import internal/card.{type DeckDesign, Card}

pub type SideStack {
  /// A stack of cards, used by each player to
  SideStack(cards: List(card.Card))
}

pub opaque type Deck {
  Deck(cards: List(card.Card))
}

fn make_deck(design: DeckDesign) {
  let blue = list.range(1, 10) |> list.map(Card(_, card.Blue, design))
  let green = list.range(1, 10) |> list.map(Card(_, card.Green, design))
  let red = list.range(1, 10) |> list.map(Card(_, card.Red, design))
  let yellow = list.range(1, 10) |> list.map(Card(_, card.Yellow, design))

  blue
  |> list.append(green)
  |> list.append(red)
  |> list.append(yellow)
}

pub fn new(design: DeckDesign) {
  make_deck(design) |> list.shuffle |> Deck
}

pub fn to_list(deck: Deck) {
  deck.cards
}

pub type Player

pub type Game {
  Game(players: List(Player))
}
