# Combine a block with defaults generated from the object
add_defaults <- function(block) {
  defaults <- object_defaults(block$object)
  
  for (tag in names(defaults)) {
    if (tag %in% names(block)) next
    
    block[[tag]] <- defaults[[tag]]
  }
  
  block
}

object_defaults <- function(x) UseMethod("object_defaults")

#' @export
object_defaults.default <- function(x) list()

#' @export
object_defaults.data <- function(x) {
  list(
    docType = "data",
    format = paste0(capture.output(str(x$value)), collapse = "\n"),
    keywords = "datasets"
  )
}

#' @export
object_defaults.s4class <- function(x) {
  list(
    docType = "class"
  )
}

#' @export
object_defaults.s4method <- function(x) {
  generic <- x$value@generic
  pkg <- attr(generic, "package")
  
  list(
    docType = "methods",
    inheritParams = inherit_from(generic, pkg)
  )
}

inherit_from <- function(generic, pkg) {
  if (pkg == "roxygen_devtest") return(generic)

  # Check that Rd file available
  rd <- get_rd(generic, pkg)
  if (is.null(rd)) return(NULL)

  str_c(pkg, "::", generic)
}
