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

pub fn new(player1, player2, player3, player4) -> Round {
  [
    #(player1, card.First),
    #(player2, card.Second),
    #(player3, card.Third),
    #(player4, card.Fourth),
  ]
  |> list.fold(dict.new(), fn(dict, player_design_pair) {
    let #(player, deck_design) = player_design_pair
    dict
    |> dict.insert(player, prepare_round(deck_design))
  })
  |> Round(color_tower: color_tower.new())
}

fn prepare_round(deck_design) {
  let player_deck = deck.new(deck_design)

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

pub fn apply_move(
  round: Round,
  player: Player,
  move: Move,
) -> Result(Round, String) {
  case dict.get(round.player_rounds, player) {
    Ok(player_round) -> {
      case move {
        TurnHandCard -> {
          let new_hand_pile = hand_pile.turn(player_round.hand_pile)
          let updated_player_round =
            PlayerRound(
              hand_pile: new_hand_pile,
              side_piles: player_round.side_piles,
              main_pile: player_round.main_pile,
            )
          dict.insert(round.player_rounds, player, updated_player_round)
          |> Round(round.color_tower)
          |> Ok
        }
        TableToColorTower(side_pile_index) -> {
          case hand_pile.play_top_card(player_round.hand_pile) {
            Ok(#(new_hand_pile, card)) -> {
              case color_tower.place_card(round.color_tower, card) {
                Ok(new_color_tower) -> {
                  let updated_player_round =
                    PlayerRound(
                      hand_pile: new_hand_pile,
                      side_piles: player_round.side_piles,
                      main_pile: player_round.main_pile,
                    )
                  dict.insert(round.player_rounds, player, updated_player_round)
                  |> Round(new_color_tower)
                  |> Ok
                }
                Error(error) -> Error("Cannot place card on color tower")
              }
            }
            Error(_) -> Error("No card to play from table")
          }
        }
        TableToSidePile(side_pile_index) -> {
          case hand_pile.play_top_card(player_round.hand_pile) {
            Ok(#(new_hand_pile, card)) -> {
              case list.at(player_round.side_piles, side_pile_index) {
                Ok(side_pile) -> {
                  case side_pile.place_card(side_pile, card) {
                    Ok(new_side_pile) -> {
                      let updated_side_piles =
                        list.set_at(
                          player_round.side_piles,
                          side_pile_index,
                          new_side_pile,
                        )
                      let updated_player_round =
                        PlayerRound(
                          hand_pile: new_hand_pile,
                          side_piles: updated_side_piles,
                          main_pile: player_round.main_pile,
                        )
                      dict.insert(
                        round.player_rounds,
                        player,
                        updated_player_round,
                      )
                      |> Round(round.color_tower)
                      |> Ok
                    }
                    Error(_) -> Error("Cannot place card on side pile")
                  }
                }
                Error(_) -> Error("Invalid side pile index")
              }
            }
            Error(_) -> Error("No card to play from table")
          }
        }
        SidePileToSidePile(from_index, to_index) -> {
          case list.at(player_round.side_piles, from_index) {
            Ok(from_pile) -> {
              case side_pile.play_top_card(from_pile) {
                Ok(#(new_from_pile, card)) -> {
                  case list.at(player_round.side_piles, to_index) {
                    Ok(to_pile) -> {
                      case side_pile.place_card(to_pile, card) {
                        Ok(new_to_pile) -> {
                          let updated_side_piles =
                            player_round.side_piles
                            |> list.set_at(from_index, new_from_pile)
                            |> list.set_at(to_index, new_to_pile)
                          let updated_player_round =
                            PlayerRound(
                              hand_pile: player_round.hand_pile,
                              side_piles: updated_side_piles,
                              main_pile: player_round.main_pile,
                            )
                          dict.insert(
                            round.player_rounds,
                            player,
                            updated_player_round,
                          )
                          |> Round(round.color_tower)
                          |> Ok
                        }
                        Error(_) ->
                          Error("Cannot place card on target side pile")
                      }
                    }
                    Error(_) -> Error("Invalid target side pile index")
                  }
                }
                Error(_) -> Error("No card to play from source side pile")
              }
            }
            Error(_) -> Error("Invalid source side pile index")
          }
        }
        SidePileToColorTower(side_pile_index) -> {
          case list.at(player_round.side_piles, side_pile_index) {
            Ok(side_pile) -> {
              case side_pile.play_top_card(side_pile) {
                Ok(#(new_side_pile, card)) -> {
                  case color_tower.place_card(round.color_tower, card) {
                    Ok(new_color_tower) -> {
                      let updated_side_piles =
                        list.set_at(
                          player_round.side_piles,
                          side_pile_index,
                          new_side_pile,
                        )
                      let updated_player_round =
                        PlayerRound(
                          hand_pile: player_round.hand_pile,
                          side_piles: updated_side_piles,
                          main_pile: player_round.main_pile,
                        )
                      dict.insert(
                        round.player_rounds,
                        player,
                        updated_player_round,
                      )
                      |> Round(new_color_tower)
                      |> Ok
                    }
                    Error(_) -> Error("Cannot place card on color tower")
                  }
                }
                Error(_) -> Error("No card to play from side pile")
              }
            }
            Error(_) -> Error("Invalid side pile index")
          }
        }
        MainPileToSidePile(side_pile_index) -> {
          case main_pile.play_top_card(player_round.main_pile) {
            Ok(#(card, new_main_pile)) -> {
              case list.at(player_round.side_piles, side_pile_index) {
                Ok(side_pile) -> {
                  case side_pile.place_card(side_pile, card) {
                    Ok(new_side_pile) -> {
                      let updated_side_piles =
                        list.set_at(
                          player_round.side_piles,
                          side_pile_index,
                          new_side_pile,
                        )
                      let updated_player_round =
                        PlayerRound(
                          hand_pile: player_round.hand_pile,
                          side_piles: updated_side_piles,
                          main_pile: new_main_pile,
                        )
                      dict.insert(
                        round.player_rounds,
                        player,
                        updated_player_round,
                      )
                      |> Round(round.color_tower)
                      |> Ok
                    }
                    Error(_) -> Error("Cannot place card on side pile")
                  }
                }
                Error(_) -> Error("Invalid side pile index")
              }
            }
            Error(_) -> Error("No card to play from main pile")
          }
        }
        MainPileToColorTower(side_pile_index) -> {
          case main_pile.play_top_card(player_round.main_pile) {
            Ok(#(card, new_main_pile)) -> {
              case color_tower.place_card(round.color_tower, card) {
                Ok(new_color_tower) -> {
                  let updated_player_round =
                    PlayerRound(
                      hand_pile: player_round.hand_pile,
                      side_piles: player_round.side_piles,
                      main_pile: new_main_pile,
                    )
                  dict.insert(round.player_rounds, player, updated_player_round)
                  |> Round(new_color_tower)
                  |> Ok
                }
                Error(_) -> Error("Cannot place card on color tower")
              }
            }
            Error(_) -> Error("No card to play from main pile")
          }
        }
      }
    }
    Error(_) -> Error("Player not found")
  }
}
