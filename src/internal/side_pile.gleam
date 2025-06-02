import gleam/bool.{guard}
import gleam/option
import gleam/pair
import internal/card.{type Card}
import internal/deck.{type Deck}
import internal/naive_stack.{type NaiveStack}

pub opaque type SidePile {
  SidePile(cards: NaiveStack(Card))
}

pub fn new(deck: Deck) -> #(SidePile, Deck) {
  deck
  |> deck.take(1)
  |> pair.map_first(naive_stack.from_list)
  |> pair.map_first(SidePile)
}

pub type PlacementError {
  NotPreviousNumber
  SameGender
  CantPlaceOver1
}

pub fn place_card(pile: SidePile, card) {
  let #(top_card, _) = get_top_card(pile)

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
        card.get_gender(top_card.color) != card.get_gender(card.color)

      use <- guard(when: !is_different_gender, return: Error(SameGender))

      naive_stack.push(pile.cards, card) |> SidePile |> Ok
    }
  }
}

pub fn get_top_card(pile: SidePile) {
  let #(remaining_stack, top_card) = pile.cards |> naive_stack.pop

  #(top_card, SidePile(remaining_stack))
}
