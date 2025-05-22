import gleam/option.{None, Some}
import internal/card.{type Card}
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
  case cards {
    [] -> Error(Nil)
    cards -> Ok(AllCardsInHand(naive_stack.from_list(cards)))
  }
}

/// Turns up to three cards from the hand onto the table.
/// If all cards are on the table, moves all cards to the hand.
/// Otherwise, if any of the three turns result in AllCardsOnTable, the function returns AllCardsOnTable.
pub fn turn(pile: HandPile) {
  case pile {
    AllCardsOnTable(table) -> AllCardsInHand(table)
    pile ->
      case turn_hand_card(pile) {
        AllCardsOnTable(table) -> AllCardsOnTable(table)
        pile -> {
          case turn_hand_card(pile) {
            AllCardsOnTable(table) -> AllCardsOnTable(table)
            pile -> turn_hand_card(pile)
          }
        }
      }
  }
}

fn turn_hand_card(pile: HandPile) {
  case pile {
    AllCardsOnTable(table) -> AllCardsInHand(table)
    AllCardsInHand(hand) -> {
      let assert #(hand, Some(card)) = naive_stack.pop(hand)
      case naive_stack.size(hand) {
        0 -> AllCardsOnTable(naive_stack.from_list([card]))
        _ -> CardsInBothPlaces(hand, naive_stack.from_list([card]))
      }
    }
    CardsInBothPlaces(hand, table) -> {
      let assert #(hand, Some(card)) = naive_stack.pop(hand)
      case naive_stack.size(hand) {
        0 -> AllCardsOnTable(naive_stack.push(table, card))
        _ -> CardsInBothPlaces(hand, naive_stack.push(table, card))
      }
    }
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
    AllCardsOnTable(table) -> {
      let #(table, card) = naive_stack.pop(table)
      case card {
        None -> Error(Nil)
        Some(card) ->
          #(AllCardsOnTable(table), card)
          |> Ok
      }
    }
    AllCardsInHand(_) -> Error(Nil)
  }
}
