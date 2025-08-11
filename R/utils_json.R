#' Wrapper for [jsonlite::write_json]
#'
#' Wrapper for [jsonlite::write_json]. Enforces that the input object is an
#'     RO-Crate.
#'
#' @inheritParams print.rocrate
#' @inheritParams jsonlite::write_json
#' @inheritDotParams jsonlite::toJSON -pretty -auto_unbox
#'
#' @returns Invisibly the input RO-Crate, `x`.
#' @export
write_json <- function(x, path, ...) {
  # check the `x` object
  is_rocrate(x)

  # store RO-Crate in JSON format
  jsonlite::write_json(x = x, path = path, pretty = TRUE, auto_unbox = TRUE, ...)

  # return (invisibly) the input object
  invisible(x)
}
