import gleam/bool.{guard}
import gleam/option
import internal/deck.{type Card}
import internal/naive_stack.{type NaiveStack}

pub opaque type SidePile {
  SidePile(cards: NaiveStack(Card))
}

pub fn new() {
  SidePile(cards: naive_stack.from_list([]))
}

pub type PlacementError {
  NotPreviousNumber
  SameGender
  CantPlaceOver1
}

pub fn place_card(pile: SidePile, card) {
  let top_card = get_top_card(pile)

  case top_card {
    option.None -> naive_stack.from_list([card]) |> SidePile |> Ok
    option.Some(top_card) -> {
      let is_1_the_top_card = top_card.number == 1
      use <- guard(when: is_1_the_top_card, return: Error(CantPlaceOver1))

      let is_new_card_number_the_previous = card.number == top_card.number - 1

      use <- guard(
        when: !is_new_card_number_the_previous,
        return: Error(NotPreviousNumber),
      )

      let is_different_gender =
        deck.get_gender(top_card.color) != deck.get_gender(card.color)

      use <- guard(when: !is_different_gender, return: Error(SameGender))

      naive_stack.push(pile.cards, card) |> SidePile |> Ok
    }
  }
}

pub fn get_top_card(pile: SidePile) {
  let #(_, top_card) = pile.cards |> naive_stack.pop
  top_card
}
