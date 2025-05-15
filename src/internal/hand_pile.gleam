import internal/deck.{type Card}

pub opaque type HandPile {
  HandPile(hand_cards: List(Card), turned_cards: List(Card))
}

pub fn new() {
  HandPile(hand_cards: [], turned_cards: [])
}
