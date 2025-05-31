import gleam/dict
import gleam/list
import gleam/option.{Some}
import gleeunit
import gleeunit/should
import internal/card.{Card}
import internal/color_tower.{
  CantPlaceOver10, ColorMismatch, FirstCardMustBe1, NotNextNumber,
}

pub fn main() {
  gleeunit.main()
}

pub fn places_card_when_empty_test() {
  let card1 = Card(color: card.Blue, number: 1, deck_design: card.First)

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
      color: card.Blue,
      number: 1,
      deck_design: card.First,
    ))

  let new_card = Card(color: card.Blue, number: 2, deck_design: card.First)

  let assert Ok(new_tower) = color_tower.place_card(tower, new_card)
  let assert Some(placed_card) = color_tower.get_top_card(new_tower)

  placed_card
  |> should.equal(new_card)
}

pub fn does_not_place_descending_card_test() {
  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(Card(
      color: card.Blue,
      number: 1,
      deck_design: card.First,
    ))

  let card_4 = Card(color: card.Blue, number: 4, deck_design: card.First)

  color_tower.place_card(tower, card_4)
  |> should.equal(Error(NotNextNumber))
}

pub fn does_not_place_card_that_is_not_next_number_test() {
  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(Card(
      color: card.Blue,
      number: 1,
      deck_design: card.First,
    ))

  let card_10 = Card(color: card.Blue, number: 10, deck_design: card.First)

  color_tower.place_card(tower, card_10)
  |> should.equal(Error(NotNextNumber))
}

pub fn does_not_place_different_color_card_test() {
  let assert Ok(tower) =
    color_tower.new()
    |> color_tower.place_card(Card(
      color: card.Blue,
      number: 1,
      deck_design: card.First,
    ))

  let green_card = Card(color: card.Green, number: 2, deck_design: card.First)

  color_tower.place_card(tower, green_card)
  |> should.equal(Error(ColorMismatch))
}

fn get_full_tower() {
  let assert Ok(tower) =
    [
      Card(color: card.Blue, number: 1, deck_design: card.First),
      Card(color: card.Blue, number: 2, deck_design: card.Second),
      Card(color: card.Blue, number: 3, deck_design: card.Second),
      Card(color: card.Blue, number: 4, deck_design: card.Second),
      Card(color: card.Blue, number: 5, deck_design: card.Third),
      Card(color: card.Blue, number: 6, deck_design: card.First),
      Card(color: card.Blue, number: 7, deck_design: card.First),
      Card(color: card.Blue, number: 8, deck_design: card.Fourth),
      Card(color: card.Blue, number: 9, deck_design: card.Second),
      Card(color: card.Blue, number: 10, deck_design: card.Second),
    ]
    |> list.try_fold(from: color_tower.new(), with: fn(tower, card) {
      color_tower.place_card(tower, card)
    })

  tower
}

pub fn calculates_total_points_for_each_deck_design_test() {
  let tower = get_full_tower()

  let totals = color_tower.calculate_total(tower) |> dict.to_list

  totals
  |> should.equal([
    #(card.First, 3),
    #(card.Second, 5),
    #(card.Third, 1),
    #(card.Fourth, 1),
  ])
}

pub fn does_not_place_on_top_of_10_test() {
  let tower =
    get_full_tower()
    |> color_tower.place_card(Card(
      color: card.Blue,
      number: 11,
      deck_design: card.Second,
    ))

  tower
  |> should.equal(Error(CantPlaceOver10))
}

pub fn does_not_place_first_card_other_than_1_test() {
  let tower =
    color_tower.new()
    |> color_tower.place_card(Card(
      color: card.Blue,
      number: 2,
      deck_design: card.Second,
    ))

  tower |> should.equal(Error(FirstCardMustBe1))
}
