import gleam/list
import internal/deck.{type Card}

// TODO: make it opaque so the list doesn't leak out of the module
pub type ColorTower {
  /// The tower of cards that every player can add cards to, in ASCENDING order, from 1 to 10.
  ColorTower(cards: List(Card))
}

pub fn new(cards) {
  ColorTower(cards)
}

pub type PlacementError {
  DescendingNotAllowed
}

/// Tries to place a card on top of the ColorTower.
/// Succeeds if the new card:
/// - matches the color of the card on top
/// - and is one number bigger than the card on top
///
/// Otherwise it returns
///
/// ```gleam
/// Error(ColorMismatch)
/// Error(DescendingNotAllowed)
/// ```
pub fn place_card(tower: ColorTower, card) {
  case tower {
    ColorTower(cards: []) -> Ok(ColorTower([card]))
    ColorTower(cards) -> {
      // we know cards list is not empty
      let assert Ok(top_card) = list.last(cards)

      case card.number > top_card.number {
        False -> Error(DescendingNotAllowed)
        True -> cards |> list.append([card]) |> ColorTower |> Ok
      }
    }
  }
}
