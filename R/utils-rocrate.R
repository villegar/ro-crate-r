#' Check if a given has the `rocrate` class
#'
#' @param rocrate RO-Crate object, see [rocrateR::rocrate].
#'
#' @returns Nothing, call for its side effect.
#'
#' @keywords internal
is_rocrate <- function(rocrate) {
  if (!"rocrate" %in% class(rocrate))
    stop("The given object is not an RO-Crate! Try running `rocrate()`, first.")
}

