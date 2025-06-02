import gleam/list
import gleam/option.{Some}
import gleam/pair
import gleeunit
import internal/card.{Card}
import internal/deck
import internal/generators
import internal/side_pile.{
  CantPlaceOver1, NotPreviousNumber, SameGender, place_card,
}
import qcheck

import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn places_card_when_empty_test() {
  let deck = deck.new(card.First)

  let assert Ok(first_card) = deck |> deck.to_list |> list.first

  let assert #(Some(card), _) =
    deck
    |> side_pile.new
    |> pair.first
    |> side_pile.get_top_card

  card
  |> should.equal(first_card)
}

pub fn the_top_card_is_always_one_less_than_the_card_below_test() {
  use pile <- qcheck.given(generators.side_pile_with_cards_generator())

  let assert #(Some(top_card), pile) =
    pile
    |> side_pile.get_top_card

  let assert #(Some(card_below), _) =
    pile
    |> side_pile.get_top_card

  top_card.number |> should.equal(card_below.number - 1)
}

pub fn does_not_place_ascending_card_test() {
  let deck =
    deck.new(card.First)
    |> drop_while(fn(n) { n == 10 || n == 1 })

  let pile =
    deck
    |> side_pile.new()
    |> pair.first

  let assert Some(first_card) = pile |> side_pile.get_top_card |> pair.first

  let ascending_card =
    Card(
      ..first_card,
      number: first_card.number + 1,
      color: get_opposite_gender(first_card.color),
    )

  pile
  |> place_card(ascending_card)
  |> should.equal(Error(NotPreviousNumber))
}

pub fn does_not_place_same_gender_card_test() {
  let deck =
    deck.new(card.First)
    |> drop_while(fn(n) { n == 10 || n == 1 })

  let pile =
    deck
    |> side_pile.new()
    |> pair.first

  let assert Some(first_card) = pile |> side_pile.get_top_card |> pair.first

  let ascending_card =
    Card(
      ..first_card,
      number: first_card.number - 1,
      // using the same color
      color: first_card.color,
    )

  pile
  |> place_card(ascending_card)
  |> should.equal(Error(SameGender))
}

pub fn does_not_place_card_on_top_of_1_test() {
  let deck =
    deck.new(card.First)
    // drop cards until we reach a number 1 card
    |> drop_while(fn(n) { n != 1 })

  let pile =
    deck
    |> side_pile.new
    |> pair.first

  let assert Some(first_card) = pile |> side_pile.get_top_card |> pair.first

  let card =
    Card(
      ..first_card,
      number: first_card.number - 1,
      color: get_opposite_gender(first_card.color),
    )

  pile
  |> place_card(card)
  |> should.equal(Error(CantPlaceOver1))
}

fn get_opposite_gender(color: card.Color) {
  case color {
    card.Blue -> card.Yellow
    card.Green -> card.Red
    card.Red -> card.Green
    card.Yellow -> card.Blue
  }
}

/// Since the cards in the deck are shuffled, we need to drop a few cards from the deck in order to be able
/// to test the placement of cards onto the side pile.
/// A card is dropped from the top of the deck, using deck.take, while the predicate fn returns True.
fn drop_while(deck: deck.Deck, predicate: fn(Int) -> Bool) {
  case deck |> deck.take(1) {
    #([Card(number: n, ..)], new_deck) ->
      case predicate(n) {
        False -> deck
        True -> drop_while(new_deck, predicate)
      }
    #(_, deck) -> deck
  }
}
