import gleam/list
import gleam/option.{type Option, None, Some}

pub opaque type NaiveStack(t) {
  NaiveStack(items: List(t))
}

pub fn from_list(list) {
  // we reverse the list because we want the top to be the first element
  list |> list.reverse |> NaiveStack
}

/// pops the top card from the NaiveStack, returning a tuple #(stack, Option(top_card))
pub fn pop(stack: NaiveStack(t)) -> #(NaiveStack(t), Option(t)) {
  case stack {
    NaiveStack([]) -> #(stack, None)
    NaiveStack([top, ..rest]) -> #(NaiveStack(rest), Some(top))
  }
}

/// pushes a value onto the NaiveStack
pub fn push(stack: NaiveStack(t), value) {
  NaiveStack([value, ..stack.items])
}

pub fn to_list(stack: NaiveStack(t)) {
  stack.items |> list.reverse
}

pub fn size(stack: NaiveStack(t)) {
  list.length(stack.items)
}
