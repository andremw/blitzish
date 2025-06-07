import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import internal/generators/deck_generators.{deck}
import internal/main_pile.{type MainPile}
import qcheck.{type Generator}

pub fn empty() -> Generator(MainPile) {
  use deck <- qcheck.map(deck())

  deck
  |> main_pile.new
  |> pair.first
  |> play_n_cards(10)
}

pub fn with_n_cards_played(n) -> Generator(MainPile) {
  use deck <- qcheck.map(deck())

  deck
  |> main_pile.new
  |> pair.first
  |> play_n_cards(n)
}

/// plays n cards from the pile, or all of them if n >= the size of the pile
fn play_n_cards(pile: MainPile, n: Int) -> MainPile {
  let length = pile |> main_pile.to_list |> list.length

  let assert Ok(pile) =
    list.range(1, int.min(length - 1, n))
    |> list.try_fold(pile, fn(pile, _) {
      pile |> main_pile.play_top_card |> result.map(pair.second)
    })

  pile
}
