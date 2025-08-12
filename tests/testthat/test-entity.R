# setup
basic_crate <- rocrate()

# create entity for an organisation
organisation_uol <- rocrateR::entity(
  x = "https://ror.org/04xs57h96",
  type = "Organization",
  name = "University of Liverpool",
  url = "http://www.liv.ac.uk"
)

# create an entity for a person
person_rvd <- rocrateR::entity(
  x = "https://orcid.org/0000-0001-5036-8661",
  type = "Person",
  name = "Roberto Villegas-Diaz",
  affiliation = list(`@id` = organisation_uol$`@id`)
)

basic_crate_v2 <- basic_crate |>
  rocrateR::add_entity(person_rvd) |>
  rocrateR::add_entity(organisation_uol)

test_that("add_entity works", {
  # attempt adding same entity without `overwrite = TRUE`
  expect_error({
    basic_crate |>
      rocrateR::add_entity(person_rvd) |>
      rocrateR::add_entity(person_rvd)
  })
})
