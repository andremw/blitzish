import gleam/list
import gleeunit
import internal/card.{type DeckDesign, Card, First}
import internal/deck

import gleeunit/should

pub fn main() {
  gleeunit.main()
}

fn make_deck(design: DeckDesign) {
  let blue = list.range(1, 10) |> list.map(Card(_, card.Blue, design))
  let green = list.range(1, 10) |> list.map(Card(_, card.Green, design))
  let red = list.range(1, 10) |> list.map(Card(_, card.Red, design))
  let yellow = list.range(1, 10) |> list.map(Card(_, card.Yellow, design))

  blue
  |> list.append(green)
  |> list.append(red)
  |> list.append(yellow)
}

pub fn creates_deck_for_deck_design_test() {
  let new_deck = deck.new(First)

  new_deck
  |> deck.to_list
  |> should.equal(make_deck(First))
}

pub fn creates_deck_with_40_cards_test() {
  let new_deck = deck.new(First)

  new_deck |> deck.to_list |> list.length |> should.equal(40)
}
