import gleam/list
import gleam/option.{type Option, None, Some}

/// A naive implementation of Stack
pub opaque type Stack(t) {
  Stack(items: List(t))
}

pub fn from_list(list) {
  // we reverse the list because we want the top to be the first element
  list |> list.reverse |> Stack
}

/// pops the top card from the Stack, returning a tuple #(stack, Option(top_card))
pub fn pop(stack: Stack(t)) -> #(Stack(t), Option(t)) {
  case stack {
    Stack([]) -> #(stack, None)
    Stack([top, ..rest]) -> #(Stack(rest), Some(top))
  }
}

/// pushes a value onto the stack
pub fn push(stack: Stack(t), value) {
  Stack([value, ..stack.items])
}
