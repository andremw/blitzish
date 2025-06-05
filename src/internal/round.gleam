import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import internal/card
import internal/color_tower.{type ColorTower}
import internal/deck.{type Deck}
import internal/hand_pile.{type HandPile}
import internal/main_pile.{type MainPile}
import internal/side_pile.{type SidePile}

// making it an alias to String for now
pub type Player {
  Player(deck_design: card.DeckDesign)
}

pub type Move {
  TurnHandCard
  TableToColorTower(Int)
  TableToSidePile(Int)
  SidePileToSidePile(Int, Int)
  SidePileToColorTower(Int)
  MainPileToSidePile(Int)
  MainPileToColorTower(Int)
}

pub type Score =
  Int

pub type Scores =
  Dict(Player, Score)

/// This record type keeps the state of a player's piles during a single round.
pub type PlayerRound {
  PlayerRound(
    hand_pile: HandPile,
    side_piles: List(SidePile),
    main_pile: MainPile,
  )
}

pub type Round {
  Round(color_tower: ColorTower, player_rounds: Dict(Player, PlayerRound))
}

pub fn new(
  player1: Player,
  player2: Player,
  player3: Player,
  player4: Player,
) -> Round {
  [player1, player2, player3, player4]
  |> list.fold(dict.new(), fn(dict, player) {
    dict
    |> dict.insert(player, prepare_round(player.deck_design))
  })
  |> Round(color_tower: color_tower.new())
}

fn prepare_round(deck_design) {
  let player_deck = deck.new(deck_design) |> deck.shuffle

  let #(side_piles, player_deck) = prepare_side_piles(player_deck)
  let #(main_pile, player_deck) = main_pile.new(player_deck)
  let #(hand_pile, _) = hand_pile.new(player_deck)

  PlayerRound(hand_pile:, side_piles:, main_pile:)
}

fn prepare_side_piles(player_deck) -> #(List(SidePile), Deck) {
  [Nil, Nil, Nil]
  |> list.fold(#([], player_deck), fn(acc, _) {
    let #(side_piles, player_deck) = acc
    let #(side_pile, player_deck) = player_deck |> side_pile.new()

    #([side_pile, ..side_piles], player_deck)
  })
}

pub fn calculate_points(round: Round) -> Dict(Player, Int) {
  let color_tower_totals = color_tower.calculate_total(round.color_tower)
  round.player_rounds
  |> dict.map_values(fn(player, player_round) {
    let color_tower_total =
      color_tower_totals |> dict.get(player.deck_design) |> result.unwrap(0)
    let points_to_deduct =
      main_pile.calculate_points_to_deduct(player_round.main_pile)

    color_tower_total - points_to_deduct
  })
}
