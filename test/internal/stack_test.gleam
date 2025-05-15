import gleam/option.{Some}
import gleeunit
import gleeunit/should
import internal/stack

pub fn main() {
  gleeunit.main()
}

pub fn creates_stack_from_list_test() {
  let expected_stack = stack.from_list([1])

  stack.from_list([1, 2])
  |> stack.pop()
  |> should.equal(#(expected_stack, Some(2)))
}
