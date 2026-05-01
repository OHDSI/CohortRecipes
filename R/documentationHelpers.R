
#' Helper for consistent documentation of `x` argument
#'
#' @param x A `cdm_table` object, it must contain `person_id` or `subject_id` as
#' columns.
#'
#' @name xDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `indexDate` argument
#'
#' @param indexDate A character string that points to a `Date` column in the `x`
#' table.
#'
#' @name indexDateDoc
#' @keywords internal
NULL

documentationWindow <- function(fun) {
  paste0(
    "Window to asses `", fun, "` in, it must be a vector of two numeric ",
    "values `c(min, max)`. Window times refer to days since `indexDate`."
  )
}

documentationConceptSet <- function(cs) {
  paste0(
    "It can either be a <codelist>, <codelist_with_details> or ",
    "<concept_set_expression> object. It must contain `",
    paste0(cs, collapse = "`, `"), "` as concepts. If `NULL` concepts will be ",
    "retrieved using the OmopConcepts package."
  )
}

#' Helper for consistent documentation of `nameStyle` argument
#'
#' @param nameStyle A character string with the name of the new column.
#'
#' @name nameStyleDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `name` argument
#'
#' @param name A character string with the name of the new table. If `NULL` a
#' temporary table will be created.
#'
#' @name nameDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `name` argument in cohorts
#'
#' @param name A character string with the name of the new cohort.
#'
#' @name nameCohortDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `cdm` argument
#'
#' @param cdm A `<cdm_reference>` object.
#'
#' @name cdmDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of addRecipeIntersect functions
#'
#' @param x
#' @param window
#' @param recipe
#' @param conceptSet
#' @param order
#' @param indexDate
#' @param censorDate
#' @param nameStyle
#' @param name
#'
#' @name cdmDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `bmiThreshold` argument
#'
#' @param bmiThreshold Argument to indicate the thresholds for the obesity using
#' BMI measurements. It can be:
#'
#' - A single number, any BMI measurement above the threshold will be consider
#' as an obesity record.
#' - A tibble with the columns `bmi_threshold`, `sex`, `age_min` and `age_max`,
#' to use age and sex specific thresholds.
#' - NULL the table `CohortRecipes::bmiThreshold` will be used.
#'
#' @name bmiThresholdDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `conceptSet` argument in recipes
#'
#' @param conceptSet It can either be a <codelist>, <codelist_with_details> or
#' <concept_set_expression> object. It must contain all the conceptSet needed
#' for the specified recipes. You can check the conceptSets needed for each
#' recipe with `recipeConcepSets()`. If `NULL` concepts will be retrieved using
#' the OmopConcepts package. If extra conceptSets are provided they will be used
#' to instantiate extra cohorts.
#'
#' @name conceptSetRecipeDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `window` argument in recipes
#'
#' @param conceptSet It can either be a <codelist>, <codelist_with_details> or
#' <concept_set_expression> object. It must contain all the conceptSet needed
#' for the specified recipes. You can check the conceptSets needed for each
#' recipe with `recipeConcepSets()`. If `NULL` concepts will be retrieved using
#' the OmopConcepts package. If extra conceptSets are provided they will be used
#' to instantiate extra cohorts.
#'
#' @name windowRecipeDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of subset arguments
#'
#' @param subsetCohort A character referring to a cohort table containing
#' individuals for whom cohorts will be generated. Only individuals in this
#' table will appear in the generated cohort.
#' @param subsetCohortId Optional. Specifies cohort IDs from the subsetCohort
#' table to include. If none are provided, all cohorts from the subsetCohort are
#' included.
#'
#' @name subsetDoc
#' @keywords internal
NULL

