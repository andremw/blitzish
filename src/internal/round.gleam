import gleam/dict.{type Dict}
import internal/card.{type Card}
import internal/color_tower.{type ColorTower}
import internal/hand_pile.{type HandPile}
import internal/naive_stack.{type NaiveStack}
import internal/side_pile.{type SidePile}

pub type Player

pub type Score =
  Int

pub type Scores =
  Dict(Player, Score)

/// This record type keeps the state of a player's piles during a single round.
pub type PlayerPiles {
  PlayerPiles(
    player: Player,
    color_tower: ColorTower,
    hand_pile: HandPile,
    side_pile: SidePile,
    // for now, I think this is just a simple stack of 10 cards
    main_pile: NaiveStack(Card),
  )
}

pub type Round {
  Round(player_piles: List(PlayerPiles), scores: Scores)
}
