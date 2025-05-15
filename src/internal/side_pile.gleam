import gleam/bool.{guard}
import gleam/list
import internal/deck.{type Card}

pub opaque type SidePile {
  SidePile(cards: List(Card))
}

pub fn new() {
  SidePile(cards: [])
}

pub type PlacementError {
  NotPreviousNumber
  SameGender
  CantPlaceOver1
}

pub fn place_card(pile: SidePile, card) {
  use <- guard(when: list.is_empty(pile.cards), return: Ok(SidePile([card])))

  let assert Ok(top_card) = list.first(pile.cards)

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

  Ok(SidePile([card, ..pile.cards]))
}

pub fn get_top_card(pile: SidePile) {
  pile.cards |> list.first
}
