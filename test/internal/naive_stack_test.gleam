import gleam/option.{Some}
import gleeunit
import gleeunit/should
import internal/naive_stack

pub fn main() {
  gleeunit.main()
}

pub fn creates_stack_from_list_test() {
  let expected_stack = naive_stack.from_list([1])

  naive_stack.from_list([1])
  |> naive_stack.push(2)
  |> naive_stack.pop()
  |> should.equal(#(expected_stack, Some(2)))
}

pub fn pushes_cards_onto_the_stack_test() {
  let expected_stack = naive_stack.from_list([1, 2, 3])

  naive_stack.from_list([])
  |> naive_stack.push(1)
  |> naive_stack.push(2)
  |> naive_stack.push(3)
  |> should.equal(expected_stack)
}
