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

/// Returns a tuple of #(n cards taken from the front, new deck with n fewer cards)
pub fn take(deck: Deck, number_of_cards: Int) -> #(List(card.Card), Deck) {
  #(
    deck.cards |> list.take(number_of_cards),
    Deck(deck.cards |> list.drop(number_of_cards)),
  )
}

pub fn to_list(deck: Deck) {
  deck.cards
}
