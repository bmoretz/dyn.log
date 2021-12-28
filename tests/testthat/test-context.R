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

test_that("call_stack_output_no_args", {

  test <- function(a, b, c) {
    wrapper <- function(x, y, z) {
      outer <- function(d, e, f) {
        inner <- function(g, h, i) {
          get_call_stack(keep_args = F,
                         filter_internal = F)
        }

        inner(d, e, f)
      }

      outer(x, y, z)
    }
    wrapper(a, b, c)
  }

  call_stack <- test(1,2,3)

  expect_true(stringr::str_detect(call_stack[[1]], "test"))
  expect_true(stringr::str_detect(call_stack[[2]], "wrapper"))
  expect_true(stringr::str_detect(call_stack[[3]], "outer"))
  expect_true(stringr::str_detect(call_stack[[4]], "inner"))
})

test_that("call_stack_output_with_args", {

  test <- function(a, b, c) {
    wrapper <- function(x, y, z) {
      outer <- function(d, e, f) {
        inner <- function(g, h, i) {
          get_call_stack(keep_args = T,
                         filter_internal = F)
        }

        inner(d, e, f)
      }

      outer(x, y, z)
    }
    wrapper(a, b, c)
  }

  call_stack <- test(1,2,3)

  expect_true(stringr::str_detect(call_stack[[1]], pattern = stringr::fixed("test(1, 2, 3)")))
  expect_true(stringr::str_detect(call_stack[[2]], pattern = stringr::fixed("wrapper(a, b, c)")))
  expect_true(stringr::str_detect(call_stack[[3]], pattern = stringr::fixed("outer(x, y, z)")))
  expect_true(stringr::str_detect(call_stack[[4]], pattern = stringr::fixed("inner(d, e, f)")))
})

test_that("execution_context_works", {

  test <- function(a, b, c) {
    wrapper <- function(x, y, z) {
      outer <- function(d, e, f) {
        inner <- function(g, h, i) {
          exec_context(filter_internal = F)
        }

        inner(d, e, f)
      }

      outer(x, y, z)
    }
    wrapper(a, b, c)
  }

  exec_contet <- test(1,2,3)

  expect_equal(class(exec_contet), c("exec_context", "context"))

  expect_equal(length(exec_contet$call_stack), 6)

  expect_true(stringr::str_detect(exec_contet$call_stack[[1]], "test"))
  expect_true(stringr::str_detect(exec_contet$call_stack[[2]], "wrapper"))
  expect_true(stringr::str_detect(exec_contet$call_stack[[3]], "outer"))
  expect_true(stringr::str_detect(exec_contet$call_stack[[4]], "inner"))

  expect_equal(exec_contet$ncalls, 6)
})

test_that("internal_calls_get_filtered", {

  call_stack <- c(call_1 = "global::test",
                  call_2 = "wrapper",
                  call_3 = "outer",
                  call_4 = "inner",
                  call_5 = "dyn.log::exec_context",
                  call_6 = "dyn.log:::get_call_stack")

  actual <- clean_internal_calls(call_stack)

  expected <- c(call_1 = "global::test",
                  call_2 = "wrapper",
                  call_3 = "outer",
                  call_4 = "inner")

  expect_equal(actual, expected)
})

test_that("internal_calls_get_filter_correctly", {

  call_stack <- c(call_1 = "global::test",
                  call_2 = "wrapper",
                  call_3 = "outer",
                  call_4 = "inner")

  actual <- clean_internal_calls(call_stack)

  expected <- c(call_1 = "global::test",
                call_2 = "wrapper",
                call_3 = "outer",
                call_4 = "inner")

  expect_equal(actual, expected)
})
