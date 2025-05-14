import gleam/dict
import gleam/list
import gleam/option.{None}
import internal/deck.{type Card}

pub opaque type ColorTower {
  /// The tower of cards that every player can add cards to, in ASCENDING order, from 1 to 10.
  ColorTower(cards: List(Card))
}

pub fn new() {
  ColorTower([])
}

/// Gets the card from the top of the tower.
/// Returns None if the tower is empty.
pub fn get_top_card(tower) {
  case tower {
    ColorTower([]) -> None
    ColorTower(cards) -> cards |> list.last |> option.from_result
  }
}

pub type PlacementError {
  ColorMismatch
  NotNextNumber
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
/// Error(NotNextNumber)
/// ```
pub fn place_card(tower: ColorTower, card) {
  case tower {
    ColorTower(cards: []) -> Ok(ColorTower([card]))
    ColorTower(cards) -> {
      // we know cards list is not empty
      let assert Ok(top_card) = list.last(cards)

      let is_next_number = card.number == top_card.number + 1
      let colors_match = card.color == top_card.color

      case is_next_number, colors_match {
        True, True -> cards |> list.append([card]) |> ColorTower |> Ok
        False, _ -> Error(NotNextNumber)
        _, False -> Error(ColorMismatch)
      }
    }
  }
}

pub type CalculationError {
  EmptyTower
}

/// Calculates the total for each deck design, each belonging to a single player.
/// Returns Error(EmptyTower) if the tower is empty.
pub fn calculate_total(tower: ColorTower) {
  case tower {
    ColorTower(cards: []) -> Error(EmptyTower)
    ColorTower(cards) ->
      cards
      |> list.group(fn(card) { card.deck_design })
      |> dict.map_values(fn(_design, cards) { list.length(cards) })
      |> dict.to_list
      |> Ok
  }
}
