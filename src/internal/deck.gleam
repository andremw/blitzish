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
  let range = list.range(1, 10)
  // all these maps and appends could be replaced by a single flat_map, but I'll keep this here for better readability
  // if it ever becomes a performance bottleneck then I'll change it
  let blue = range |> list.map(Card(_, card.Blue, design))
  let green = range |> list.map(Card(_, card.Green, design))
  let red = range |> list.map(Card(_, card.Red, design))
  let yellow = range |> list.map(Card(_, card.Yellow, design))

  blue
  |> list.append(green)
  |> list.append(red)
  |> list.append(yellow)
}

pub fn new(design: DeckDesign) -> Deck {
  make_deck(design) |> Deck
}

pub fn shuffle(deck: Deck) -> Deck {
  deck.cards |> list.shuffle |> Deck
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

pub fn size(deck: Deck) {
  deck |> to_list |> list.length
}
