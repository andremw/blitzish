import internal/card.{Card}
import internal/deck.{type Deck}

/// Since the cards in the deck are shuffled, sometimes we need to drop a few cards from the deck in order to be able
/// to test the placement of cards.
/// A card is dropped from the top of the deck, using deck.take, while the predicate fn returns True.
pub fn drop_while(deck: Deck, predicate: fn(Int) -> Bool) {
  case deck |> deck.take(1) {
    #([Card(number: n, ..)], new_deck) ->
      case predicate(n) {
        False -> deck
        True -> drop_while(new_deck, predicate)
      }
    #(_, deck) -> deck
  }
}
