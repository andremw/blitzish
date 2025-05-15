import gleam/list
import gleam/option.{Some}
import gleeunit
import gleeunit/should
import internal/color_tower.{
  CantPlaceOver10, ColorMismatch, FirstCardMustBe1, NotNextNumber,
}
import internal/deck.{Card}

pub fn main() {
  gleeunit.main()
}

pub fn places_card_when_empty_test() {
  let card1 = Card(color: deck.Blue, number: 1, deck_design: deck.First)

  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(card1)

  let assert Some(placed_card) = color_tower.get_top_card(tower)

  placed_card
  |> should.equal(card1)
}

// gleeunit test functions end in `_test`
pub fn places_ascending_cards_test() {
  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(Card(
      color: deck.Blue,
      number: 1,
      deck_design: deck.First,
    ))

  let new_card = Card(color: deck.Blue, number: 2, deck_design: deck.First)

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
      number: 1,
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
      number: 1,
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
      number: 1,
      deck_design: deck.First,
    ))

  let green_card = Card(color: deck.Green, number: 2, deck_design: deck.First)

  color_tower.place_card(tower, green_card)
  |> should.equal(Error(ColorMismatch))
}

fn get_full_tower() {
  let assert Ok(tower) =
    [
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
    |> list.try_fold(from: color_tower.new(), with: fn(tower, card) {
      color_tower.place_card(tower, card)
    })

  tower
}

pub fn calculates_total_points_for_each_deck_design_test() {
  let tower = get_full_tower()

  let assert Ok(totals) = color_tower.calculate_total(tower)

  totals
  |> should.equal([
    #(deck.First, 3),
    #(deck.Second, 5),
    #(deck.Third, 1),
    #(deck.Fourth, 1),
  ])
}

pub fn does_not_place_on_top_of_10_test() {
  let tower =
    get_full_tower()
    |> color_tower.place_card(Card(
      color: deck.Blue,
      number: 11,
      deck_design: deck.Second,
    ))

  tower
  |> should.equal(Error(CantPlaceOver10))
}

pub fn does_not_place_first_card_other_than_1_test() {
  let tower =
    color_tower.new()
    |> color_tower.place_card(Card(
      color: deck.Blue,
      number: 2,
      deck_design: deck.Second,
    ))

  tower |> should.equal(Error(FirstCardMustBe1))
}
