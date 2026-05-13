
recipeEnd <- dplyr::tribble(
  ~recipe, ~exit,
  "obesity", Inf
)
recipeConcepts <- dplyr::tribble(
  ~recipe, ~concept_set, ~filter,
  "obesity", "obesity_condition", list(),
  "obesity", "obesity_measurement", list("1234" = c(4, 50))
)

usethis::use_data(recipeEnd, recipeConcepts, internal = TRUE, overwrite = TRUE)
