import gleam/option
import gleam/pair
import internal/card.{type Card}
import internal/deck.{type Deck}
import internal/naive_stack.{type NaiveStack}

pub opaque type MainPile {
  MainPile(cards: NaiveStack(Card))
  MainPileFinished
}

pub fn new(deck: Deck) -> #(MainPile, Deck) {
  let #(main_pile, deck) =
    deck
    |> deck.take(10)
    |> pair.map_first(naive_stack.from_list)
    |> pair.map_first(MainPile)

  #(main_pile, deck)
}

pub fn calculate_points_to_deduct(pile: MainPile) {
  case pile {
    MainPile(cards) -> { cards |> naive_stack.size } * 2
    MainPileFinished -> 0
  }
}

pub fn play_top_card(pile: MainPile) -> Result(#(Card, MainPile), Nil) {
  case pile {
    MainPile(cards) -> {
      let #(pile_stack, card) = cards |> naive_stack.pop

      case card {
        option.None -> Error(Nil)
        // this shouldn't happen
        option.Some(card) ->
          case pile_stack |> naive_stack.size == 0 {
            False -> Ok(#(card, MainPile(pile_stack)))
            True -> Ok(#(card, MainPileFinished))
          }
      }
    }
    MainPileFinished -> Error(Nil)
  }
}

pub fn is_finished(pile: MainPile) {
  case pile {
    MainPile(_) -> False
    MainPileFinished -> True
  }
}
