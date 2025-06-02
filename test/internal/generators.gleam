import gleam/list
import internal/card.{type DeckDesign, Card}
import internal/color_tower
import internal/deck.{type Deck}
import qcheck

pub fn deck_generator() -> qcheck.Generator(Deck) {
  use design <- qcheck.map(deck_design_generator())

  deck.new(design)
}

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
