import gleam/option.{Some}
import gleeunit
import gleeunit/should
import internal/stack

pub fn main() {
  gleeunit.main()
}

pub fn creates_stack_from_list_test() {
  let expected_stack = stack.from_list([1])

  stack.from_list([1])
  |> stack.push(2)
  |> stack.pop()
  |> should.equal(#(expected_stack, Some(2)))
}

pub fn pushes_cards_onto_the_stack_test() {
  let expected_stack = stack.from_list([1, 2, 3])

  stack.from_list([])
  |> stack.push(1)
  |> stack.push(2)
  |> stack.push(3)
  |> should.equal(expected_stack)
}
