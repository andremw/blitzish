pub type Gender {
  Boy
  Girl
}

pub type Color {
  Blue
  Yellow
  Red
  Green
}

/// We'll need to think about the possible deck types here.
/// But it's more of a visual thing, not a super important part of the state
pub type DeckDesign {
  First
  Second
  Third
  Fourth
}

/// Gets the gender related to the color.
/// For Red and Blue, it returns Boy.
/// For Green and Yellow, it returns Girl.
pub fn get_gender(color) {
  case color {
    Red | Blue -> Boy
    Green | Yellow -> Girl
  }
}

pub type Card {
  Card(number: Int, color: Color, deck_design: DeckDesign)
}
