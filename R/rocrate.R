#' Create a new RO-Crate object
#'
#' Create a new RO-Crate object. This object includes basic skeleton for the
#' RO-Crate metadata descriptor (`ro-crate-metadata.json`) file, as described
#' in the official documentation: https://w3id.org/ro/crate/1.2 >
#' [Root Data Entity](https://www.researchobject.org/ro-crate/specification/1.2/root-data-entity.html).
#'
#' @param ... Optional entities to include in the RO-Crate (e.g., author).
#' @param context String with URL to the version of the RO-Crate specification
#'     to use. The context brings the defined terms into the metadata document.
#' @param conformsTo String with URL to the version of the RO-Crate
#'     specification which this object conforms to. Conformance declares which
#'     RO-Crate conventions of using those terms are being followed.
#'
#' @returns RO-Crate object, list with an additional class, {rocrate}.
#' @export
#'
#' @examples
#' rocrateR::rocrate()
rocrate <- function(...,
                    context = "https://w3id.org/ro/crate/1.2/context",
                    conformsTo = gsub("\\/context$", "\\1", context)) {
  new_ro_crate <- list(
    `@context` = context,
    `@graph` = list(
      list(
        `@id` = "ro-crate-metadata.json",
        `@type` = "CreativeWork",
        about = list(`@id` = "./"),
        conformsTo = list(`@id` = conformsTo)
      ),
      list(
        `@id` = "./",
        `@type` = "Dataset"#,
        # hasPart = list(),
      )
    )
  )

  # capture additional entities
  extra_entities <- .capture_extra_entities(...)
  extra_entities_tbl <- tibble::tibble(
    ent = extra_entities,
    ent_name = names(extra_entities),
    required = list(c("@id", "@type"))
  )

  # validate any additional entities
  idx <- seq_len(nrow(extra_entities_tbl)) |>
    sapply(\(i) do.call(.validate_entity, lapply(extra_entities_tbl, `[[`, i)))

  # combine the base crate with any extra entities
  if (length(idx) > 0)
    new_ro_crate$`@graph` <- c(new_ro_crate$`@graph`, unname(extra_entities[idx]))

  # set class for the new object
  class(new_ro_crate) <- c("rocrate", class(new_ro_crate))

  return(new_ro_crate)
}

#' Create a new 5 Safes RO-Crate object
#'
#' Create a new 5 Safes RO-Crate object. This object includes basic skeleton
#' for the RO-Crate metadata descriptor (`ro-crate-metadata.json`) file, as
#' described in the official documentation: https://w3id.org/ro/crate/1.2 >
#' [Root Data Entity](https://www.researchobject.org/ro-crate/specification/1.2/root-data-entity.html).
#' Additionally, it includes a profile for the 5 Safes RO-Crate:
#' https://w3id.org/5s-crate/0.4
#'
#' @inheritParams rocrate
#' @param v5scrate Numeric value with the version of the 5 Safes RO-Crate
#'     profile to use.
#'
#' @returns 5 Safes RO-Crate object, list with an additional class, {rocrate}.
#' @export
#'
#' @examples
#' rocrateR::rocrate_5s()
rocrate_5s <- function(...,
                       context = "https://w3id.org/ro/crate/1.2/context",
                       conformsTo = gsub("\\/context$", "\\1", context),
                       v5scrate = 0.4) {
  # create entity for the 5 safes profile
  v5scrate_id <- paste0("https://w3id.org/5s-crate/", v5scrate)
  prof_5scrate <- list(
    `@id` = v5scrate_id,
    `@type` = "Profile",
    name = "Five Safes RO-Crate profile"
  )

  # create basic RO-Crate
  new_ro_crate <- rocrate(..., context = context, conformsTo = conformsTo)

  # edit the new RO-Crate
  new_ro_crate <- new_ro_crate |>
    # attach the 5 safes profile entity
    add_entity(prof_5scrate) |>
    # update the root entity's conformsTo property
    add_entity_value(
      id = "./",
      key = "conformsTo",
      value = list(`@id` = paste0("https://w3id.org/5s-crate/", v5scrate))
    )

  # return the new RO-Crate with the 5 safes profile
  return(new_ro_crate)
}
