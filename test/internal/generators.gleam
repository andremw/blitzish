// not sure about how much logic I should put in here, but /shrug

import gleam/int
import gleam/list
import gleam/option.{Some}
import internal/card.{type DeckDesign, Card}
import internal/color_tower
import internal/deck_test_helpers
import internal/generators/deck_generators.{deck}
import internal/side_pile
import qcheck

fn deck_design_generator() -> qcheck.Generator(DeckDesign) {
  qcheck.from_generators(qcheck.constant(card.First), [
    qcheck.constant(card.Second),
    qcheck.constant(card.Third),
    qcheck.constant(card.Fourth),
  ])
}

pub fn card_props_generator() -> qcheck.Generator(
  #(Int, card.Color, card.DeckDesign),
) {
  use number, color, deck_design <- qcheck.map3(
    qcheck.bounded_int(1, 10),
    card_color_generator(),
    deck_design_generator(),
  )

  #(number, color, deck_design)
}

fn card_color_generator() {
  qcheck.from_generators(qcheck.constant(card.Blue), [
    qcheck.constant(card.Red),
    qcheck.constant(card.Yellow),
    qcheck.constant(card.Green),
  ])
}

pub fn full_tower_generator() {
  use #(_, color, deck_design) <- qcheck.map(card_props_generator())

  let assert Ok(tower) =
    [
      Card(color:, number: 1, deck_design:),
      Card(color:, number: 2, deck_design:),
      Card(color:, number: 3, deck_design:),
      Card(color:, number: 4, deck_design:),
      Card(color:, number: 5, deck_design:),
      Card(color:, number: 6, deck_design:),
      Card(color:, number: 7, deck_design:),
      Card(color:, number: 8, deck_design:),
      Card(color:, number: 9, deck_design:),
      Card(color:, number: 10, deck_design:),
    ]
    |> list.try_fold(from: color_tower.new(), with: fn(tower, card) {
      color_tower.place_card(tower, card)
    })

  tower
}

/// returns a ColorTower with 1 to 9 cards placed
pub fn tower_with_cards_generator() {
  use #(_, color, deck_design), number <- qcheck.map2(
    card_props_generator(),
    qcheck.bounded_int(1, 9),
  )

  let tower = color_tower.new()

  let assert Ok(tower) =
    list.range(1, number)
    // using positional args here for partial application of Card
    |> list.map(Card(_, color, deck_design))
    |> list.try_fold(from: tower, with: color_tower.place_card)

  tower
}

pub fn side_pile_with_cards_generator() {
  use deck <- qcheck.bind(deck())
  let deck = deck |> deck_test_helpers.drop_while(fn(n) { n == 1 })
  let #(pile, _) = side_pile.new(deck)

  // get the top card to make sure we place cards in descending order, starting from the
  // number in the top card
  let assert #(Some(top_card), _) = pile |> side_pile.get_top_card
  let Card(color: top_card_color, deck_design: deck_design, number: number) =
    top_card
  use opposite_gender_color <- qcheck.map(opposite_gender_generator(
    top_card_color,
  ))

  let assert Ok(pile) =
    // creating a list that goes from the top card's number to 1, like [3, 2, 1]
    list.range(int.max(number - 1, 1), 1)
    |> list.index_map(fn(number, index) {
      // alternating genders on every even index since 0
      let color = case int.is_even(index) {
        True -> {
          opposite_gender_color
        }
        False -> top_card_color
      }

      Card(number, color, deck_design)
    })
    |> list.try_fold(from: pile, with: side_pile.place_card)

  pile
}

pub fn opposite_gender_generator(color: card.Color) {
  case card.get_gender(color) {
    card.Boy ->
      qcheck.from_generators(qcheck.constant(card.Green), [
        qcheck.constant(card.Yellow),
      ])
    card.Girl ->
      qcheck.from_generators(qcheck.constant(card.Blue), [
        qcheck.constant(card.Red),
      ])
  }
}
