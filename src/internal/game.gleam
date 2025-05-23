import gleam/dict.{type Dict}

pub type AccumulatedScore =
  Int

pub type Player {
  Player(accumulated_score: AccumulatedScore)
}

pub type RoundScore =
  Int

pub type PlayerScore =
  #(Player, RoundScore, AccumulatedScore)

pub type Round {
  Started(scores: List(PlayerScore))
  Finished(scores: List(PlayerScore))
}

pub type Game {
  Running(
    players: Dict(String, Player),
    current_round: Round,
    previous_rounds: List(Round),
  )
  Ended(players: Dict(String, Player), winner: Player)
}
