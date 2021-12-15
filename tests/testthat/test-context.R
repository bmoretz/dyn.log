test_that("basic_case",{

  func <- ".inner(d, e, f)"
  actual <- extract_func_name(func)

  expect_equal(actual, ".inner")
})

test_that("obj_init",{

  func <- "Test$new(d, e, f)"
  actual <- extract_func_name(func)

  expect_equal(actual, "Test$new")
})

test_that("call_stack_output", {

  test <- function(a, b, c) {
    wrapper <- function(x, y, z) {
      outer <- function(d, e, f) {
        inner <- function(g, h, i) {
          get_call_stack()
        }

        inner(d, e, f)
      }

      outer(x, y, z)
    }
    wrapper(a, b, c)
  }

  call_stack <- test(1,2,3)

  # account for test_that's call stack
  test_that_offset <- which(!is.na(match(call_stack, 'test')), arr.ind = T)

  make_callstack <- function(value, level) {
    val <- c(value)
    names(val) <- paste0('callstack_', level)
    val
  }

  expected_level_one <- make_callstack('test', test_that_offset)
  expect_equal(call_stack[test_that_offset], expected_level_one)

  test_that_offset <- test_that_offset+1;

  expected_level_two <- make_callstack('wrapper', test_that_offset)
  expect_equal(call_stack[test_that_offset], expected_level_two)

  test_that_offset <- test_that_offset+1;

  expected_level_three <- make_callstack('outer', test_that_offset)
  expect_equal(call_stack[test_that_offset], expected_level_three)

  test_that_offset <- test_that_offset+1;

  expected_level_four <- make_callstack('inner', test_that_offset)
  expect_equal(call_stack[test_that_offset], expected_level_four)
})

# test_that("call_stack_outputs_with_args", {
#
#   # get 3rd level of the call stack
#   fmt_callstack <- new_fmt_call_stack(crayon::magenta$bold, 3, keep_args = T)
#
#   test <- function(a, b, c) {
#     wrapper <- function(x, y, z) {
#       outer <- function(d, e, f) {
#         inner <- function(g, h, i) {
#           value(fmt_callstack)
#         }
#
#         inner(d, e, f)
#       }
#
#       outer(x, y, z)
#     }
#     wrapper(a, b, c)
#   }
#
#   actual <- test()
#
#   expected <- 'inner(d, e, f) outer(x, y, z) wrapper(a, b, c) test()'
#
#   #expect_equal(actual, expected)
# })

# test_that("call_stack_outputs_no_args", {
#
#   # get 3rd level of the call stack
#   fmt_callstack <- new_fmt_call_stack(crayon::magenta$bold, 3)
#
#   test <- function(a, b, c) {
#     wrapper <- function(x, y, z) {
#       outer <- function(d, e, f) {
#         inner <- function(g, h, i) {
#           value(fmt_callstack)
#         }
#
#         inner(d, e, f)
#       }
#
#       outer(x, y, z)
#     }
#     wrapper(a, b, c)
#   }
#
#   actual <- test()
#
#   expected <- 'inner outer wrapper test'
#
#   # expect_equal(actual, expected)
# })
