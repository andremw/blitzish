import gleam/option.{Some}
import gleam/result
import gleeunit
import internal/card.{Card}
import internal/side_pile.{
  CantPlaceOver1, NotPreviousNumber, SameGender, get_top_card, place_card,
}

import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn places_card_when_empty_test() {
  let card = Card(color: card.Blue, deck_design: card.First, number: 5)

  let assert Ok(pile) =
    side_pile.new()
    |> place_card(card)

  let assert Some(top_card) = get_top_card(pile)

  top_card
  |> should.equal(card)
}

pub fn places_descending_card_test() {
  let second_card = Card(color: card.Blue, deck_design: card.First, number: 4)
  let assert Ok(pile) =
    side_pile.new()
    |> place_card(Card(color: card.Yellow, deck_design: card.First, number: 5))
    // since place_card returns a Result, to pipe it we need to use result.try, so it unwraps the value inside Ok
    // (which is a SidePile), and passes it into place_card, in the first position
    |> result.try(place_card(_, second_card))

  let assert Some(top_card) = get_top_card(pile)

  top_card
  |> should.equal(second_card)
}

pub fn does_not_place_ascending_card_test() {
  let pile =
    side_pile.new()
    |> place_card(Card(color: card.Blue, deck_design: card.First, number: 5))
    |> result.try(place_card(
      _,
      Card(color: card.Yellow, deck_design: card.First, number: 6),
    ))

  pile
  |> should.equal(Error(NotPreviousNumber))
}

pub fn does_not_place_same_gender_card_test() {
  let pile =
    side_pile.new()
    |> place_card(Card(color: card.Blue, deck_design: card.First, number: 5))
    |> result.try(place_card(
      _,
      Card(color: card.Blue, deck_design: card.First, number: 4),
    ))

  pile
  |> should.equal(Error(SameGender))
}

pub fn does_not_place_card_on_top_of_1_test() {
  let pile =
    side_pile.new()
    |> place_card(Card(color: card.Blue, deck_design: card.First, number: 1))
    |> result.try(place_card(
      _,
      Card(color: card.Yellow, deck_design: card.First, number: 0),
    ))

  pile
  |> should.equal(Error(CantPlaceOver1))
}
