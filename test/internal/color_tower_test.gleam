import gleam/dict
import gleam/option.{Some}
import gleeunit
import gleeunit/should
import internal/card.{Card}
import internal/color_tower.{
  CantPlaceOver10, ColorMismatch, FirstCardMustBe1, NotNextNumber,
}
import internal/generators
import qcheck

pub fn main() {
  gleeunit.main()
}

pub fn places_card_when_empty_test() {
  use #(_, color, deck_design) <- qcheck.given(
    generators.card_props_generator(),
  )
  let card1 = Card(color:, number: 1, deck_design:)

  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(card1)

  let assert Some(placed_card) = color_tower.get_top_card(tower)

  placed_card
  |> should.equal(card1)
}

// gleeunit test functions end in `_test`
pub fn places_ascending_cards_test() {
  use #(_, color, deck_design) <- qcheck.given(
    generators.card_props_generator(),
  )

  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(Card(color:, number: 1, deck_design:))

  let new_card = Card(color:, number: 2, deck_design:)

  let assert Ok(new_tower) = color_tower.place_card(tower, new_card)
  let assert Some(placed_card) = color_tower.get_top_card(new_tower)

  placed_card
  |> should.equal(new_card)
}

pub fn does_not_place_descending_card_test() {
  use #(_, color, deck_design) <- qcheck.given(
    generators.card_props_generator(),
  )

  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(Card(color:, number: 1, deck_design:))

  let card_4 = Card(color:, number: 4, deck_design:)

  color_tower.place_card(tower, card_4)
  |> should.equal(Error(NotNextNumber))
}

pub fn does_not_place_card_that_is_not_next_number_test() {
  use #(_, color, deck_design) <- qcheck.given(
    generators.card_props_generator(),
  )

  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(Card(color:, number: 1, deck_design:))

  let card_10 = Card(color:, number: 10, deck_design:)

  color_tower.place_card(tower, card_10)
  |> should.equal(Error(NotNextNumber))
}

pub fn does_not_place_different_color_card_test() {
  use #(_, _, deck_design) <- qcheck.given(generators.card_props_generator())

  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(Card(color: card.Blue, number: 1, deck_design:))

  let green_card = Card(color: card.Green, number: 2, deck_design:)

  color_tower.place_card(tower, green_card)
  |> should.equal(Error(ColorMismatch))
}

pub fn each_placed_card_adds_one_point_for_the_deck_design_test() {
  use tower <- qcheck.given(generators.tower_with_cards_generator())

  let assert Some(top_card) = tower |> color_tower.get_top_card

  let assert Ok(previous_total) =
    tower |> color_tower.calculate_total() |> dict.get(top_card.deck_design)

  let assert Ok(tower) =
    tower
    |> color_tower.place_card(Card(..top_card, number: top_card.number + 1))

  let assert Ok(new_total) =
    tower |> color_tower.calculate_total() |> dict.get(top_card.deck_design)

  new_total
  |> should.equal(previous_total + 1)
}

pub fn does_not_place_on_top_of_10_test() {
  use tower <- qcheck.given(generators.full_tower_generator())

  let assert Some(top_card) = tower |> color_tower.get_top_card

  let tower =
    tower
    |> color_tower.place_card(Card(
      color: top_card.color,
      number: 11,
      deck_design: top_card.deck_design,
    ))

  tower
  |> should.equal(Error(CantPlaceOver10))
}

pub fn does_not_place_first_card_other_than_1_test() {
  use #(_, color, deck_design) <- qcheck.given(
    generators.card_props_generator(),
  )

  let tower =
    color_tower.new()
    |> color_tower.place_card(Card(color:, number: 2, deck_design:))

  tower |> should.equal(Error(FirstCardMustBe1))
}
