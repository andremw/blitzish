import gleeunit
import gleeunit/should
import internal/color_tower.{ColorTower}
import internal/deck.{Card}

pub fn main() {
  gleeunit.main()
}

pub fn places_card_when_empty_test() {
  let tower = color_tower.new([])
  let card5 = Card(color: deck.Blue, gender: deck.Boy, number: 5)

  tower
  |> color_tower.place_card(card5)
  |> should.equal(Ok(ColorTower([card5])))
}

// gleeunit test functions end in `_test`
pub fn places_ascending_cards_test() {
  let card5 = Card(color: deck.Blue, gender: deck.Boy, number: 5)
  let tower = color_tower.new([card5])

  let new_card = Card(color: deck.Blue, gender: deck.Boy, number: 6)

  tower
  |> color_tower.place_card(new_card)
  |> should.equal(Ok(ColorTower([card5, new_card])))
}

pub fn does_not_place_descending_card_test() {
  1 |> should.equal(1)
}

pub fn does_not_place_different_color_card_test() {
  1 |> should.equal(1)
}
