import gleam/list
import gleam/option.{Some}
import gleeunit
import gleeunit/should
import internal/color_tower.{ColorMismatch, NotNextNumber}
import internal/deck.{Card}

pub fn main() {
  gleeunit.main()
}

pub fn places_card_when_empty_test() {
  let tower = color_tower.new()
  let card5 = Card(color: deck.Blue, number: 5, deck_design: deck.First)

  let assert Ok(new_tower) = color_tower.place_card(tower, card5)

  let assert Some(placed_card) = color_tower.get_top_card(new_tower)

  placed_card
  |> should.equal(card5)
}

// gleeunit test functions end in `_test`
pub fn places_ascending_cards_test() {
  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(Card(
      color: deck.Blue,
      number: 5,
      deck_design: deck.First,
    ))

  let new_card = Card(color: deck.Blue, number: 6, deck_design: deck.First)

  let assert Ok(new_tower) = color_tower.place_card(tower, new_card)
  let assert Some(placed_card) = color_tower.get_top_card(new_tower)

  placed_card
  |> should.equal(new_card)
}

pub fn does_not_place_descending_card_test() {
  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(Card(
      color: deck.Blue,
      number: 5,
      deck_design: deck.First,
    ))

  let card_4 = Card(color: deck.Blue, number: 4, deck_design: deck.First)

  color_tower.place_card(tower, card_4)
  |> should.equal(Error(NotNextNumber))
}

pub fn does_not_place_card_that_is_not_next_number_test() {
  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(Card(
      color: deck.Blue,
      number: 5,
      deck_design: deck.First,
    ))

  let card_10 = Card(color: deck.Blue, number: 10, deck_design: deck.First)

  color_tower.place_card(tower, card_10)
  |> should.equal(Error(NotNextNumber))
}

pub fn does_not_place_different_color_card_test() {
  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(Card(
      color: deck.Blue,
      number: 5,
      deck_design: deck.First,
    ))

  let green_card = Card(color: deck.Green, number: 6, deck_design: deck.First)

  color_tower.place_card(tower, green_card)
  |> should.equal(Error(ColorMismatch))
}

pub fn calculates_total_points_for_each_deck_design_test() {
  let tower = color_tower.new()
  // we want to add all cards to the new tower, from 1 to 10
  let cards = [
    Card(color: deck.Blue, number: 1, deck_design: deck.First),
    Card(color: deck.Blue, number: 2, deck_design: deck.Second),
    Card(color: deck.Blue, number: 3, deck_design: deck.Second),
    Card(color: deck.Blue, number: 4, deck_design: deck.Second),
    Card(color: deck.Blue, number: 5, deck_design: deck.Third),
    Card(color: deck.Blue, number: 6, deck_design: deck.First),
    Card(color: deck.Blue, number: 7, deck_design: deck.First),
    Card(color: deck.Blue, number: 8, deck_design: deck.Fourth),
    Card(color: deck.Blue, number: 9, deck_design: deck.Second),
    Card(color: deck.Blue, number: 10, deck_design: deck.Second),
  ]

  let assert Ok(tower) =
    list.try_fold(over: cards, from: tower, with: fn(tower, card) {
      color_tower.place_card(tower, card)
    })

  let assert Ok(totals) = color_tower.calculate_total(tower)

  totals
  |> should.equal([
    #(deck.First, 3),
    #(deck.Second, 5),
    #(deck.Third, 1),
    #(deck.Fourth, 1),
  ])
}
