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
  let card5 = Card(color: deck.Blue, gender: deck.Boy, number: 5)

  let assert Ok(new_tower) = color_tower.place_card(tower, card5)

  let assert Some(placed_card) = color_tower.get_top_card(new_tower)

  placed_card
  |> should.equal(card5)
}

// gleeunit test functions end in `_test`
pub fn places_ascending_cards_test() {
  let card5 = Card(color: deck.Blue, gender: deck.Boy, number: 5)
  let tower = color_tower.new([card5])

  let new_card = Card(color: deck.Blue, gender: deck.Boy, number: 6)

  let assert Ok(new_tower) = color_tower.place_card(tower, new_card)
  let assert Some(placed_card) = color_tower.get_top_card(new_tower)

  placed_card
  |> should.equal(new_card)
}

pub fn does_not_place_descending_card_test() {
  let card5 = Card(color: deck.Blue, gender: deck.Boy, number: 5)
  let tower = color_tower.new([card5])

  let card_4 = Card(color: deck.Blue, gender: deck.Boy, number: 4)

  color_tower.place_card(tower, card_4)
  |> should.equal(Error(NotNextNumber))
}

pub fn does_not_place_different_color_card_test() {
  let blue_card = Card(color: deck.Blue, gender: deck.Boy, number: 5)
  let tower = color_tower.new([blue_card])

  let green_card = Card(color: deck.Green, gender: deck.Boy, number: 6)

  color_tower.place_card(tower, green_card)
  |> should.equal(Error(ColorMismatch))
}
