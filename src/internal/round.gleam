import gleam/bool.{guard}
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
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
  Running(
    color_towers: List(ColorTower),
    player_rounds: Dict(Player, PlayerRound),
  )
  Ended(
    color_towers: List(ColorTower),
    player_rounds: Dict(Player, PlayerRound),
  )
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
  |> Running(color_towers: [color_tower.new()])
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
  let combine = fn(a, b) { dict.combine(a, b, int.add) }
  let color_tower_totals =
    round.color_towers
    |> list.map(color_tower.calculate_total)
    |> list.fold(dict.new(), combine)

  round.player_rounds
  |> dict.map_values(fn(player, player_round) {
    let color_tower_total =
      color_tower_totals |> dict.get(player.deck_design) |> result.unwrap(0)
    let points_to_deduct =
      main_pile.calculate_points_to_deduct(player_round.main_pile)

    color_tower_total - points_to_deduct
  })
}

pub type MoveError {
  SidePileNotFound
  PlayerNotFound
  InvalidMove(message: Option(String))
}

// -> Result(Round, MoveError)
pub fn move(
  round: Round,
  player: Player,
  move: Move,
) -> Result(Round, MoveError) {
  case move {
    MainPileToSidePile(pile_index) -> {
      use player_round <- result.try(
        dict.get(round.player_rounds, player) |> or_player_not_found,
      )

      use side_pile <- result.try(
        player_round.side_piles
        |> find_by_index(pile_index)
        |> or_side_pile_not_found,
      )

      use #(card, main_pile) <- result.try(
        player_round.main_pile
        |> main_pile.play_top_card
        |> or_invalid_move(fn(_) { InvalidMove(None) }),
      )

      // after the card's taken from the MainPile, we try to place it on the side_pile.
      // if invalid, we just ignore the move.
      // if valid, _then_ we look at the MainPile and see if it's empty, finishing the Round if it is, continuing if not.

      use _ <- result.try(
        side_pile
        |> side_pile.place_card(card)
        |> or_invalid_move(fn(error) {
          InvalidMove(Some(side_pile.placement_error_to_string(error)))
        }),
      )

      use <- guard(
        when: main_pile.is_finished(main_pile),
        return: Ok(Ended(round.color_towers, round.player_rounds)),
      )

      Ok(round)
    }
    MainPileToColorTower(_) -> todo
    SidePileToColorTower(_) -> todo
    SidePileToSidePile(_, _) -> todo
    TableToColorTower(_) -> todo
    TableToSidePile(_) -> todo
    TurnHandCard -> todo
  }
}

fn or_player_not_found(r) {
  r |> result.map_error(fn(_) { PlayerNotFound })
}

fn or_side_pile_not_found(o) {
  o |> option.to_result(SidePileNotFound)
}

fn or_invalid_move(r, on_error) {
  r |> result.map_error(on_error)
}

fn find_by_index(a_list: List(a), index: Int) -> Option(a) {
  a_list
  |> list.index_fold(None, fn(_, item, i) {
    case i == index {
      False -> None
      True -> Some(item)
    }
  })
}
