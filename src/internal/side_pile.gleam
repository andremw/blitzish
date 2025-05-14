import gleam/list
import internal/deck.{type Card}

pub type SidePile {
  SidePile(cards: List(Card))
}

pub fn new() {
  SidePile(cards: [])
}

pub type PlacementError {
  NotPreviousNumber
}

pub fn place_card(pile: SidePile, card) {
  case pile.cards {
    [] -> Ok(SidePile(list.append(pile.cards, [card])))
    cards -> {
      let assert Ok(top_card) = list.last(cards)

      let is_new_card_number_the_previous = card.number == top_card.number - 1

      case is_new_card_number_the_previous {
        False -> Error(NotPreviousNumber)
        True -> Ok(SidePile(list.append(pile.cards, [card])))
      }
    }
  }
}

pub fn get_top_card(pile: SidePile) {
  pile.cards |> list.last
}
