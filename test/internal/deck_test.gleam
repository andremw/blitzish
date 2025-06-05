import gleam/dict
import gleam/list
import gleeunit
import internal/card
import internal/deck

import gleeunit/should
import internal/generators/deck_generators.{deck}
import qcheck

pub fn main() {
  gleeunit.main()
}

pub fn creates_shuffled_deck_with_40_cards_test() {
  use new_deck <- qcheck.given(deck())

  new_deck |> deck.to_list |> list.length |> should.equal(40)
}

pub fn creates_deck_with_10_cards_each_color_test() {
  use new_deck <- qcheck.given(deck())
  let new_deck_list = new_deck |> deck.to_list

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

pub fn all_cards_in_the_deck_are_between_1_and_10_test() {
  use new_deck <- qcheck.given(deck())

  let new_deck_list = new_deck |> deck.to_list

  list.all(new_deck_list, fn(card) { card.number >= 1 && card.number <= 10 })
  |> should.be_true
}

pub fn remaining_deck_has_correct_size_after_taking_cards_test() {
  use first_deck <- qcheck.given(deck())

  let number_of_cards_to_take = 7
  let #(_, new_deck) = first_deck |> deck.take(number_of_cards_to_take)

  deck.size(new_deck)
  |> should.equal(deck.size(first_deck) - number_of_cards_to_take)
}
