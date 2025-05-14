import gleam/option.{Some}
import gleeunit
import gleeunit/should
import internal/color_tower.{ColorMismatch, NotNextNumber}
import internal/deck.{Card}

pub fn main() {
  gleeunit.main()
}

pub fn places_card_when_empty_test() {
  let tower = color_tower.new([])
  let card5 =
    Card(color: deck.Blue, gender: deck.Boy, number: 5, deck_design: deck.First)

  let assert Ok(new_tower) = color_tower.place_card(tower, card5)

  let assert Some(placed_card) = color_tower.get_top_card(new_tower)

  placed_card
  |> should.equal(card5)
}

// gleeunit test functions end in `_test`
pub fn places_ascending_cards_test() {
  let card5 =
    Card(color: deck.Blue, gender: deck.Boy, number: 5, deck_design: deck.First)
  let tower = color_tower.new([card5])

  let new_card =
    Card(color: deck.Blue, gender: deck.Boy, number: 6, deck_design: deck.First)

  let assert Ok(new_tower) = color_tower.place_card(tower, new_card)
  let assert Some(placed_card) = color_tower.get_top_card(new_tower)

  placed_card
  |> should.equal(new_card)
}

pub fn does_not_place_descending_card_test() {
  let card5 =
    Card(color: deck.Blue, gender: deck.Boy, number: 5, deck_design: deck.First)
  let tower = color_tower.new([card5])

  let card_4 =
    Card(color: deck.Blue, gender: deck.Boy, number: 4, deck_design: deck.First)

  color_tower.place_card(tower, card_4)
  |> should.equal(Error(NotNextNumber))
}

pub fn does_not_place_card_that_is_not_next_number_test() {
  let card5 =
    Card(color: deck.Blue, gender: deck.Boy, number: 5, deck_design: deck.First)
  let tower = color_tower.new([card5])

  let card_10 =
    Card(
      color: deck.Blue,
      gender: deck.Boy,
      number: 10,
      deck_design: deck.First,
    )

  color_tower.place_card(tower, card_10)
  |> should.equal(Error(NotNextNumber))
}

pub fn does_not_place_different_color_card_test() {
  let blue_card =
    Card(color: deck.Blue, gender: deck.Boy, number: 5, deck_design: deck.First)
  let tower = color_tower.new([blue_card])

  let green_card =
    Card(
      color: deck.Green,
      gender: deck.Boy,
      number: 6,
      deck_design: deck.First,
    )

  color_tower.place_card(tower, green_card)
  |> should.equal(Error(ColorMismatch))
}

pub fn calculates_total_points_for_each_deck_design_test() {
  let tower =
    color_tower.new([
      Card(
        color: deck.Blue,
        gender: deck.Boy,
        number: 1,
        deck_design: deck.First,
      ),
      Card(
        color: deck.Blue,
        gender: deck.Boy,
        number: 2,
        deck_design: deck.Second,
      ),
      Card(
        color: deck.Blue,
        gender: deck.Boy,
        number: 3,
        deck_design: deck.Second,
      ),
      Card(
        color: deck.Blue,
        gender: deck.Boy,
        number: 4,
        deck_design: deck.Second,
      ),
      Card(
        color: deck.Blue,
        gender: deck.Boy,
        number: 5,
        deck_design: deck.Third,
      ),
      Card(
        color: deck.Blue,
        gender: deck.Boy,
        number: 6,
        deck_design: deck.First,
      ),
      Card(
        color: deck.Blue,
        gender: deck.Boy,
        number: 7,
        deck_design: deck.First,
      ),
      Card(
        color: deck.Blue,
        gender: deck.Boy,
        number: 8,
        deck_design: deck.Fourth,
      ),
      Card(
        color: deck.Blue,
        gender: deck.Boy,
        number: 9,
        deck_design: deck.Second,
      ),
      Card(
        color: deck.Blue,
        gender: deck.Boy,
        number: 10,
        deck_design: deck.Second,
      ),
    ])

  let assert Ok(totals) = color_tower.calculate_total(tower)

  totals
  |> should.equal([
    #(deck.First, 3),
    #(deck.Second, 5),
    #(deck.Third, 1),
    #(deck.Fourth, 1),
  ])
}
