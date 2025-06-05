import gleam/list
import gleam/pair
import gleam/result
import internal/generators
import internal/main_pile.{type MainPile}
import qcheck.{type Generator}

pub fn empty() -> Generator(MainPile) {
  use deck <- qcheck.map(generators.deck_generator())

  deck
  |> main_pile.new
  |> pair.first
  |> play_all_cards
}

fn play_all_cards(pile: MainPile) -> MainPile {
  let length = pile |> main_pile.to_list |> list.length

  let assert Ok(pile) =
    list.range(1, length - 1)
    |> list.try_fold(pile, fn(pile, _) {
      pile |> main_pile.play_top_card |> result.map(pair.second)
    })

  pile
}
