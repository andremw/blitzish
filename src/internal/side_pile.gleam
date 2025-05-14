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
  SameGender
}

pub fn place_card(pile: SidePile, card) {
  case pile.cards {
    [] -> Ok(SidePile(list.append(pile.cards, [card])))
    cards -> {
      let assert Ok(top_card) = list.last(cards)

      let is_new_card_number_the_previous = card.number == top_card.number - 1
      let is_different_gender =
        deck.get_gender(top_card.color) != deck.get_gender(card.color)

      case is_new_card_number_the_previous, is_different_gender {
        True, True -> Ok(SidePile(list.append(pile.cards, [card])))
        False, _ -> Error(NotPreviousNumber)
        _, False -> Error(SameGender)
      }
    }
  }
}

pub fn get_top_card(pile: SidePile) {
  pile.cards |> list.last
}
