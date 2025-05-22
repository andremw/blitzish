import gleam/list
import gleam/option.{type Option, None, Some}

pub opaque type NaiveStack(t) {
  NaiveStack(items: List(t))
}

/// Iterates over the list, stacking each item on top of the previous one.
/// This means that a list of [1,2] will have 2 on top of 1.
///
/// ### Examples
/// ```gleam
/// naive_stack.from_list([1, 2])
/// |> naive_stack.pop() // #(NaiveStack, Some(2))
/// ```
pub fn from_list(list) {
  // we reverse the list because we want the top to be the first element
  list |> list.reverse |> NaiveStack
}

/// pops the top card from the NaiveStack, returning a tuple #(stack, Option(top_card)),
/// where the first element is a new stack with the top element removed.
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
  stack.items
}

pub fn size(stack: NaiveStack(t)) {
  list.length(stack.items)
}
