context("Alias")
roc <- rd_roclet()

test_that("aliases split into pieces", {
  out <- roc_proc_text(roc, "
    #' @aliases a b
    #' @name a
    NULL")[[1]]
  
  expect_match(get_tag(out, "alias")$values, fixed("a"), all = FALSE)
  expect_match(get_tag(out, "alias")$values, fixed("b"), all = FALSE)
})


test_that("aliases escaped, not quoted", {
  out1 <- roc_proc_text(roc, "
    #' @aliases a
    #' @name %a%
    NULL")[[1]]
  out2 <- roc_proc_text(roc, "
    #' @aliases %a%
    #' @name a
    NULL")[[1]]
  alias1 <- format(get_tag(out1, "alias"))
  alias2 <- format(get_tag(out2, "alias"))
  expect_equal(alias1, c("\\alias{\\%a\\%}\n", "\\alias{a}\n"))
  expect_equal(alias2, c("\\alias{\\%a\\%}\n", "\\alias{a}\n"))
})
