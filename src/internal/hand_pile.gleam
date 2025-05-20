import gleam/bool.{guard}
import gleam/list
import gleam/option.{None, Some}
import internal/deck.{type Card}
import internal/naive_stack.{type NaiveStack}

/// The HandPile can be in three possible states, each restricting the next possible actions.
pub opaque type HandPile {
  /// All cards have been turned onto the table, there's none left in the player's hand. In this case, the only possible
  /// action is to put the cards back in the hand.
  AllCardsOnTable(table_cards: NaiveStack(Card))
  /// All cards are in the player's hand, there's none on the table. In this case, it's possible to start turning the cards
  /// onto the table.
  AllCardsInHand(hand_cards: NaiveStack(Card))
  /// The player has started to turn cards, some are on the table, some are in his hands.
  CardsInBothPlaces(hand_cards: NaiveStack(Card), table_cards: NaiveStack(Card))
}

/// Creates a new hand pile as AllCardsInHand
pub fn new(cards) {
  AllCardsInHand(naive_stack.from_list(cards |> list.reverse()))
}

pub fn turn(pile: HandPile) {
  case pile {
    AllCardsInHand(hand) -> {
      let #(hand, card1) = naive_stack.pop(hand)

      // this should never happen, unless the HandPile was initialized with no cards.
      use <- guard(when: option.is_none(card1), return: Error(Nil))

      let #(hand, card2) = naive_stack.pop(hand)

      use <- guard(when: option.is_none(card2), return: {
        let assert Some(card1) = card1
        Ok(CardsInBothPlaces(hand, naive_stack.from_list([card1])))
      })

      let assert #(Some(card1), Some(card2)) = #(card1, card2)
      Ok(CardsInBothPlaces(hand, naive_stack.from_list([card1, card2])))
    }
    AllCardsOnTable(_) -> todo
    CardsInBothPlaces(_, _) -> todo
  }
}

pub fn to_list(pile: HandPile) {
  case pile {
    AllCardsInHand(hand) -> #(naive_stack.to_list(hand), [])
    AllCardsOnTable(table) -> #([], naive_stack.to_list(table))
    CardsInBothPlaces(hand, table) -> #(
      naive_stack.to_list(hand),
      naive_stack.to_list(table),
    )
  }
}

pub fn play_top_card(pile: HandPile) {
  case pile {
    CardsInBothPlaces(hand, table) -> {
      let #(new_table, card) = naive_stack.pop(table)
      case card {
        None -> Error(Nil)
        Some(card) ->
          #(CardsInBothPlaces(hand, new_table), card)
          |> Ok
      }
    }
    AllCardsInHand(_) -> todo
    AllCardsOnTable(_) -> todo
  }
}
