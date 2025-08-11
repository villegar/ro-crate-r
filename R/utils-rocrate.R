#' Check if a given has the `rocrate` class
#'
#' @param rocrate RO-Crate object, see [rocrateR::rocrate].
#'
#' @returns Nothing, call for its side effect.
#'
#' @keywords internal
is_rocrate <- function(rocrate) {
  # has the 'rocrate' class
  has_rocrate_class <- "rocrate" %in% class(rocrate)

  # extract main value for @context
  ro_crate_context <- getElement(rocrate, "@context")

  # has a valid @context -- TOO SLOW
  # has_valid_context <- ro_crate_context |>
  #   sapply(\(x) RCurl::url.exists(x)) |>
  #   any()
  has_valid_context <- TRUE

  # extract @graph
  ro_crate_graph <- getElement(rocrate, "@graph")

  # extract @graph elements' @id
  graph_ids <- ro_crate_graph |>
    sapply(`[[`, "@id")

  # extract @graph elements' @type
  graph_types <- ro_crate_graph |>
    sapply(`[[`, "@type")

  # check lengths of @ids and @types, must be the same
  valid_length_graph <- length(graph_ids) == length(graph_types)

  # has an RO-Crate Metadata descriptor entity
  has_rocrate_meta <- "ro-crate-metadata.json" %in% graph_ids

  # has a root entity
  has_root <- "./" %in% graph_ids

  msg <- ""
  if (!has_rocrate_class)
    msg <- "- Missing 'rocrate' class.\n"
  if (!has_valid_context)
    msg <- paste0(msg, "- Invalid value for @context: ", paste0(ro_crate_context, collapse = "; "), ".\n")
  if (is.null(ro_crate_graph))
    msg <- paste0(msg, "- The @graph section is missing.\n")
  if (!valid_length_graph)
    msg <- paste0(msg, "- The entities in @graph are NOT valid (e.g., missing @id and/or @type).\n")
  if (!has_rocrate_meta)
    msg <- paste0(msg, "- Missing the entity for the RO-Crate Metadata descriptor, ",
                  "@id = 'ro-crate-metadata.json'.\n")
  if (!has_root)
    msg <- paste0(msg, "- Missing the root entity, @id = './'.\n")
  if (nchar(msg) > 0) {
    stop("Invalid RO-Crate object! Try running `rocrate()`, first.\n",
         "Identified issue(s):\n",
         msg)
  }
}

