import gleam/list
import internal/deck.{type Card}
import internal/naive_stack.{type NaiveStack}

/// The HandPile can be in three possible states, each restricting the next possible actions.
pub opaque type HandPile {
  /// All cards have been turned onto the table, there's none left in the player's hand. In this case, the only possible
  /// action is to put the cards back in the hand.
  AllCardsOnTable(table_cards: NaiveStack(Card))
  /// All cards are in the player's hand, there's none on the table. In this case, it's possible to start turning the cards
  /// onto the table.
  AllCardsInHand(hand_cards: List(Card))
  /// The player has started to turn cards, some are on the table, some are in his hands.
  CardsInBothPlaces(hand_cards: NaiveStack(Card), table_cards: NaiveStack(Card))
}

/// Creates a new hand pile as AllCardsInHand
pub fn new(cards) {
  AllCardsInHand(cards)
}
