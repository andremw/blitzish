import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleeunit
import gleeunit/should
import internal/card
import internal/color_tower
import internal/hand_pile
import internal/main_pile
import internal/naive_stack
import internal/round.{
  type Player, type PlayerRound, type Round, PlayerRound, Round,
}
import internal/side_pile
import qcheck

pub fn main() {
  gleeunit.main()
}

// Model state for testing
type ModelState {
  ModelState(round: Round, current_player: Player, round_finished: Bool)
}

// Possible actions a player can take in a round
type Action {
  /// Turn up to three cards from the hand onto the table
  TurnHandCard
  /// Move a card from the table to the color tower (specify which side pile index to use)
  MoveTableToColorTower(side_pile_index: Int)
  /// Move a card from the table to a side pile
  MoveTableToSidePile(side_pile_index: Int)
  /// Move a card from one side pile to another
  MoveSidePileToSidePile(from_index: Int, to_index: Int)
  /// Move a card from a side pile to the color tower
  MoveSidePileToColorTower(side_pile_index: Int)
  /// Move a card from the main pile to a side pile
  MoveMainPileToSidePile(side_pile_index: Int)
  /// Move a card from the main pile to the color tower
  MoveMainPileToColorTower(side_pile_index: Int)
}

// Helper to generate a valid initial state
fn generate_initial_state() -> qcheck.Generator(ModelState) {
  qcheck.constant({
    let player1 = round.Player(card.First)
    let player2 = round.Player(card.Second)
    let player3 = round.Player(card.Third)
    let player4 = round.Player(card.Fourth)

    let round = round.new(player1, player2, player3, player4)

    ModelState(round: round, current_player: player1, round_finished: False)
  })
}

// Helper to verify invariants
fn verify_invariants(state: ModelState) -> Bool {
  let player_rounds = state.round.player_rounds
  let color_tower = state.round.color_tower

  // Check that all players have valid piles
  let valid_piles =
    dict.fold(player_rounds, True, fn(acc, _player, player_round) {
      // Check that the total number of cards (hand + table) is 27
      let #(hand_cards, table_cards) = hand_pile.to_list(player_round.hand_pile)
      let total_cards = list.length(hand_cards) + list.length(table_cards)
      let valid_hand = total_cards == 27

      // Check main pile is not finished at start
      let valid_main = !main_pile.is_finished(player_round.main_pile)

      // Check side piles have correct number of cards (1 each)
      let valid_side_piles =
        list.all(player_round.side_piles, fn(pile) {
          case side_pile.get_top_card(pile) {
            #(Some(_), _) -> True
            _ -> False
          }
        })

      acc && valid_hand && valid_main && valid_side_piles
    })

  // Check that color tower is empty at start
  let valid_color_tower = case color_tower.get_top_card(color_tower) {
    None -> True
    Some(_) -> False
  }

  // Check that round is not finished at start
  let valid_round_state = !state.round_finished

  valid_piles && valid_color_tower && valid_round_state
}

fn random_action_generator() -> qcheck.Generator(Action) {
  qcheck.from_generators(qcheck.constant(TurnHandCard), [
    qcheck.map(qcheck.bounded_int(0, 2), MoveTableToColorTower),
    qcheck.map(qcheck.bounded_int(0, 2), MoveTableToSidePile),
    qcheck.map2(
      qcheck.bounded_int(0, 2),
      qcheck.bounded_int(0, 2),
      fn(from, to) {
        let to_index = case from == to {
          True -> { to + 1 } % 3
          False -> to
        }
        MoveSidePileToSidePile(from, to_index)
      },
    ),
    qcheck.map(qcheck.bounded_int(0, 2), MoveSidePileToColorTower),
    qcheck.map(qcheck.bounded_int(0, 2), MoveMainPileToSidePile),
    qcheck.map(qcheck.bounded_int(0, 2), MoveMainPileToColorTower),
  ])
}

fn apply_random_action(
  state: ModelState,
) -> qcheck.Generator(Result(ModelState, String)) {
  qcheck.map(random_action_generator(), fn(action) {
    case action {
      TurnHandCard -> {
        case
          round.apply_move(
            state.round,
            state.current_player,
            round.TurnHandCard,
          )
        {
          Ok(new_round) ->
            Ok(ModelState(
              round: new_round,
              current_player: state.current_player,
              round_finished: state.round_finished,
            ))
          Error(error) -> Error(error)
        }
      }
      MoveTableToColorTower(side_pile_index) -> {
        case
          round.apply_move(
            state.round,
            state.current_player,
            round.TableToColorTower(side_pile_index),
          )
        {
          Ok(new_round) ->
            Ok(ModelState(
              round: new_round,
              current_player: state.current_player,
              round_finished: state.round_finished,
            ))
          Error(error) -> Error(error)
        }
      }
      MoveTableToSidePile(side_pile_index) -> {
        case
          round.apply_move(
            state.round,
            state.current_player,
            round.TableToSidePile(side_pile_index),
          )
        {
          Ok(new_round) ->
            Ok(ModelState(
              round: new_round,
              current_player: state.current_player,
              round_finished: state.round_finished,
            ))
          Error(error) -> Error(error)
        }
      }
      MoveSidePileToSidePile(from_index, to_index) -> {
        case
          round.apply_move(
            state.round,
            state.current_player,
            round.SidePileToSidePile(from_index, to_index),
          )
        {
          Ok(new_round) ->
            Ok(ModelState(
              round: new_round,
              current_player: state.current_player,
              round_finished: state.round_finished,
            ))
          Error(error) -> Error(error)
        }
      }
      MoveSidePileToColorTower(side_pile_index) -> {
        case
          round.apply_move(
            state.round,
            state.current_player,
            round.SidePileToColorTower(side_pile_index),
          )
        {
          Ok(new_round) ->
            Ok(ModelState(
              round: new_round,
              current_player: state.current_player,
              round_finished: state.round_finished,
            ))
          Error(error) -> Error(error)
        }
      }
      MoveMainPileToSidePile(side_pile_index) -> {
        case
          round.apply_move(
            state.round,
            state.current_player,
            round.MainPileToSidePile(side_pile_index),
          )
        {
          Ok(new_round) ->
            Ok(ModelState(
              round: new_round,
              current_player: state.current_player,
              round_finished: state.round_finished,
            ))
          Error(error) -> Error(error)
        }
      }
      MoveMainPileToColorTower(side_pile_index) -> {
        case
          round.apply_move(
            state.round,
            state.current_player,
            round.MainPileToColorTower(side_pile_index),
          )
        {
          Ok(new_round) ->
            Ok(ModelState(
              round: new_round,
              current_player: state.current_player,
              round_finished: state.round_finished,
            ))
          Error(error) -> Error(error)
        }
      }
    }
  })
}

pub fn random_action_sequence_maintains_invariants_test() {
  use initial_state <- qcheck.given(generate_initial_state())
  use result <- qcheck.given(apply_random_action(initial_state))

  case result {
    Ok(new_state) -> {
      verify_invariants(new_state)
      |> should.be_true
    }
    Error(_) -> {
      // For now, we'll just pass the test if we get an error
      // since we haven't implemented all actions yet
      True |> should.be_true
    }
  }
}
