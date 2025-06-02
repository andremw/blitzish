import gleam/dict
import gleam/list
import gleeunit
import internal/card
import internal/deck

import gleeunit/should
import internal/generators
import qcheck

pub fn main() {
  gleeunit.main()
}

pub fn creates_shuffled_deck_with_40_cards_test() {
  use design <- qcheck.given(generators.deck_design_generator())
  let new_deck = deck.new(design)

  new_deck |> deck.to_list |> list.length |> should.equal(40)
}

pub fn creates_deck_with_10_cards_each_color_test() {
  use design <- qcheck.given(generators.deck_design_generator())
  let new_deck_list = deck.new(design) |> deck.to_list

  let grouped_cards = new_deck_list |> list.group(fn(card) { card.color })

  let assert Ok(blue_cards) = grouped_cards |> dict.get(card.Blue)
  let assert Ok(red_cards) = grouped_cards |> dict.get(card.Red)
  let assert Ok(yellow_cards) = grouped_cards |> dict.get(card.Yellow)
  let assert Ok(green_cards) = grouped_cards |> dict.get(card.Green)

  blue_cards |> list.length |> should.equal(10)
  red_cards |> list.length |> should.equal(10)
  yellow_cards |> list.length |> should.equal(10)
  green_cards |> list.length |> should.equal(10)
}
