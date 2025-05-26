import gleam/bool.{guard}
import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import internal/card.{type Card}
import internal/naive_stack.{type NaiveStack}

pub opaque type ColorTower {
  /// The tower of cards that every player can add cards to, in ASCENDING order, from 1 to 10.
  ColorTower(cards: NaiveStack(Card))
}

pub fn new() {
  ColorTower(naive_stack.from_list([]))
}

/// Gets the card from the top of the tower.
/// Returns None if the tower is empty.
pub fn get_top_card(tower: ColorTower) {
  let #(_, card) = naive_stack.pop(tower.cards)
  card
}

pub type PlacementError {
  ColorMismatch
  NotNextNumber
  CantPlaceOver10
  FirstCardMustBe1
}

/// Tries to place a card on top of the ColorTower.
/// Succeeds if the new card:
/// - is 1 when the tower is empty, or when the card on top is not 10 (which means, tower is full)
/// - matches the color of the card on top
/// - and is one number bigger than the card on top
pub fn place_card(tower: ColorTower, card: Card) {
  let top_card = get_top_card(tower)
  case top_card {
    None -> {
      use <- guard(when: card.number != 1, return: Error(FirstCardMustBe1))

      [card] |> naive_stack.from_list |> ColorTower |> Ok
    }
    Some(top_card) -> {
      let is_10_the_top_card = top_card.number == 10

      use <- guard(when: is_10_the_top_card, return: Error(CantPlaceOver10))

      let is_next_number = card.number == top_card.number + 1

      use <- guard(when: !is_next_number, return: Error(NotNextNumber))

      let colors_match = card.color == top_card.color

      use <- guard(when: !colors_match, return: Error(ColorMismatch))

      tower.cards |> naive_stack.push(card) |> ColorTower |> Ok
    }
  }
}

/// Calculates the total for each deck design, each belonging to a single player.
/// Returns Error(EmptyTower) if the tower is empty.
///
/// This will be used to calculate the points from each tower in a hand (or round) once the hand finishes.
pub fn calculate_total(tower: ColorTower) {
  naive_stack.to_list(tower.cards)
  |> list.group(fn(card) { card.deck_design })
  |> dict.map_values(fn(_design, cards) { list.length(cards) })
  |> dict.to_list
}
