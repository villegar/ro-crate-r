#' Add entity to RO-Crate
#'
#' @inheritParams is_rocrate
#' @param entity Entity object (list) that contains at least the following
#'     components: `@id` and `@type`.
#' @param overwrite Boolean flag to indicate if the entity (if found in the
#'     given RO-Crate) should be overwritten.
#'
#' @returns Updated RO-Crate with the new entity
#' @export
#'
#' @examples
#' basic_crate <- rocrate()
#'
#' # create entity for an organisation
#' organisation_uol <- rocrateR::data_entity(
#'   x = "https://ror.org/04xs57h96",
#'   type = "Organization",
#'   name = "University of Liverpool",
#'   url = "http://www.liv.ac.uk"
#' )
#'
#' # create an entity for a person
#' person_rvd <- rocrateR::data_entity(
#'   x = "https://orcid.org/0000-0001-5036-8661",
#'   type = "Person",
#'   name = "Roberto Villegas-Diaz",
#'   affiliation = list(`@id` = organisation_uol$`@id`)
#' )
#'
#' basic_crate_v2 <- basic_crate |>
#'   rocrateR::add_entity(person_rvd) |>
#'   rocrateR::add_entity_value(id = "./", key = "author", value = list(`@id` = person_rvd$`@id`)) |>
#'   rocrateR::add_entity(organisation_uol)
add_entity <- function(rocrate, entity, overwrite = FALSE) {
  # check the `rocrate` object
  is_rocrate(rocrate)

  # validate entity
  .validate_entity(entity)

  # verify if the `entity` exists in the given crate
  idx <- .find_id_index(rocrate, getElement(entity, "@id"))

  if (sum(idx) > 0) {
    if (!overwrite) {
      stop("The entity, `@id = '", getElement(entity, "@id"),
           "'`, is part of the RO-Crate, `rocrate`. \n",
           "Try a different `@id` or set `overwrite = TRUE`.")
    }
    warning("Overwritting the entity with @id = '",
            getElement(entity, "@id"), "'")

    rocrate$`@graph`[idx][[1]] <- entity
  }
  else {
    rocrate$`@graph` <- c(rocrate$`@graph`, list(entity))
  }

  return(rocrate)
}

#' Add entity value to RO-Crate
#'
#' Add entity value to RO-Crate, under entity with `@id` = {id}, using the
#' pair {key}-{value} within `@graph`.
#'
#' @inheritParams is_rocrate
#' @param id String with the ID of the RO-Crate entity within `@graph`
#' @param key String with the `key` of the entity with `id` to be modified.
#' @param value String with the `value` for `key`.
#' @param overwrite Boolean flag to indicate if the existing value (if any),
#'     should be overwritten (default: `TRUE`).
#'
#' @returns RO-Crate object
#' @export
#'
#' @examples
#' basic_crate <- rocrate()
#'
#' # create entity for an organisation
#' organisation_uol <- rocrateR::data_entity(
#'   x = "https://ror.org/04xs57h96",
#'   type = "Organization",
#'   name = "University of Liverpool",
#'   url = "http://www.liv.ac.uk"
#' )
#'
#' # create an entity for a person
#' person_rvd <- rocrateR::data_entity(
#'   x = "https://orcid.org/0000-0001-5036-8661",
#'   type = "Person",
#'   name = "Roberto Villegas-Diaz",
#'   affiliation = list(`@id` = organisation_uol$`@id`)
#' )
#'
#' basic_crate_v2 <- basic_crate |>
#'   rocrateR::add_entity_value(id = "./", key = "author", value = list(`@id` = person_rvd$`@id`))
add_entity_value <- function(rocrate, id, key, value, overwrite = TRUE) {
  # check the `rocrate` object
  is_rocrate(rocrate)

  # find the index in `@graph` with the matching {id}
  idx <- rocrate$`@graph` |>
    sapply(\(x) getElement(x, "@id") == id && (overwrite || is.null(getElement(x, key))))
  # verify that only one index was found for the matching {id}
  if(sum(idx) != 1) {
    stop("Please, ensure the given {id} is unique and part of the RO-Crate.")
  }
  # set the new {value} for {key} associated to {id}
  rocrate$`@graph`[idx][[1]][key] <- list(value)
  return(rocrate)
}

#' Create a data entity
#'
#' @param x New entity. If a single value (e.g., `character`, `numeric`) is
#'     given, this is assumed to be the entity's `@id`, if a `list` is given,
#'     this is assumed to be a complete entity. Other options are objects of
#'     type `person` and `organisation` (equivalenly `organization`).
#' @param ... Optional additional entity values/properties. Used when `x` is
#'     a single value.
#'
#' @returns List with a data entity object.
#' @export
#'
#' @examples
#' # create entity for an organisation
#' organisation_uol <- rocrateR::data_entity(
#'   x = "https://ror.org/04xs57h96",
#'   type = "Organization",
#'   name = "University of Liverpool",
#'   url = "http://www.liv.ac.uk"
#' )
#'
#' # create an entity for a person
#' person_rvd <- rocrateR::data_entity(
#'   x = "https://orcid.org/0000-0001-5036-8661",
#'   type = "Person",
#'   name = "Roberto Villegas-Diaz",
#'   affiliation = list(`@id` = organisation_uol$`@id`)
#' )
#'
data_entity <- function(x, ...) {
  if (!.validate_entity(x, ...)) {
    stop("Invalid data entity (see above)!")
  }
  UseMethod("data_entity", x)
}

#' @export
data_entity.default <- function(x, ...) {
  args <- list(...)
  list(
    `@id` = c(x, getElement(args, "id"))[1],
    `@type` = getElement(args, "type")
  ) |>
    # append any additional properties
    c(suppressWarnings(within(args, rm(id, type))))
}

#' @export
data_entity.organisation <- function(x, ...) {
  data_entity.organization(x, ...)
}

#' @export
data_entity.organization <- function(x, ...) {
  args <- list(...)
  list(`@id` = getElement(args, "id"), `@type` = "Organization")
}

#' @export
data_entity.person <- function(x, ...) {
  args <- list(...)
  list(`@id` = getElement(args, "id"), `@type` = "Person")
}
