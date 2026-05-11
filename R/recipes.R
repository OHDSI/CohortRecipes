
#' Create a recipe cohort
#'
#' @inheritParams xDoc
#' @inheritParams nameDoc
#' @inheritParams recipeDoc
#' @inheritParams conceptSetRecipeDoc
#' @inheritParams subsetDoc
#'
#' @returns A `<cohort_table>` object.
#'
#' @export
#'
#' @examples
#' library(CohortRecipes)
#'
recipeCohort <- function(cdm,
                         name,
                         recipe,
                         conceptSet = NULL,
                         subsetCohort = NULL,
                         subsetCohortId = NULL) {
  cohortRecipeInternal(
    cdm = cdm,
    name = name,
    recipe = recipe,
    conceptSet = conceptSet,
    subsetCohort = subsetCohort,
    subsetCohortId = {{subsetCohortId}}
  )
}

#' Add columns to indicate the presence or not of `recipe` cohorts
#'
#' @inheritParams xDoc
#' @inheritParams windowRecipeDoc
#' @inheritParams recipeDoc
#' @inheritParams conceptSetRecipeDoc
#' @param indexDate
#' @param censorDate
#' @inheritParams nameStyleDoc
#' @inheritParams nameDoc
#'
#' @returns
#' @export
#'
#' @examples
addRecipeIntersectFlag <- function(x,
                                   window,
                                   recipe,
                                   conceptSet = NULL,
                                   indexDate = NULL,
                                   censorDate = NULL,
                                   nameStyle = "{window}_{recipe}",
                                   name = NULL) {
  addRecipe(
    x = x,
    recipe = recipe,
    conceptSet = conceptSet,
    value = "flag",
    window = window,
    indexDate = indexDate,
    censorDate = censorDate,
    nameStyle = nameStyle,
    name = name
  )
}

#' Title
#'
#' @param x
#' @param window
#' @param recipe
#' @param conceptSet
#' @param indexDate
#' @param censorDate
#' @param nameStyle
#' @param name
#'
#' @returns
#' @export
#'
addRecipeIntersectCount <- function(x,
                                    window,
                                    recipe,
                                    conceptSet = NULL,
                                    indexDate = NULL,
                                    censorDate = NULL,
                                    nameStyle = "{window}_{recipe}",
                                    name = NULL) {
  addRecipe(
    x = x,
    recipe = recipe,
    conceptSet = conceptSet,
    value = "count",
    window = window,
    indexDate = indexDate,
    censorDate = censorDate,
    nameStyle = nameStyle,
    name = name
  )
}

#' Title
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
#' @returns
#' @export
#'
#' @examples
addRecipeIntersectDays <- function(x,
                                   window,
                                   recipe,
                                   conceptSet = NULL,
                                   order = "first",
                                   indexDate = NULL,
                                   censorDate = NULL,
                                   nameStyle = "{window}_{recipe}",
                                   name = NULL) {
  addRecipe(
    x = x,
    recipe = recipe,
    conceptSet = conceptSet,
    value = "days",
    window = window,
    order = order,
    indexDate = indexDate,
    censorDate = censorDate,
    nameStyle = nameStyle,
    name = name
  )
}

#' Title
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
#' @returns
#' @export
#'
#' @examples
addRecipeIntersectDate <- function(x,
                                   window,
                                   recipe,
                                   conceptSet = NULL,
                                   order = "first",
                                   indexDate = NULL,
                                   censorDate = NULL,
                                   nameStyle = "{window}_{recipe}",
                                   name = NULL) {
  addRecipe(
    x = x,
    recipe = recipe,
    conceptSet = conceptSet,
    value = "date",
    window = window,
    order = order,
    indexDate = indexDate,
    censorDate = censorDate,
    nameStyle = nameStyle,
    name = name
  )
}

cohortRecipeInternal <- function(cdm,
                                 name,
                                 recipe,
                                 conceptSet,
                                 subsetCohort,
                                 subsetCohortId,
                                 call = parent.frame()) {
  # initial checks
  cdm <- omopgenerics::validateCdmArgument(cdm = cdm, call = call)
  name <- omopgenerics::validateNameArgument(name = name, cdm = cdm, validation = "warning")
  recipe <- validateRecipe(recipe, conceptSet, call = call)
  conceptSet <- validateConceptSet(conceptSet, recipe, call = call)
  omopgenerics::assertCharacter(subsetCohort, length = 1, null = TRUE, call = call)
  prefix <- omopgenerics::tmpPrefix()
  on.exit(omopgenerics::dropSourceTable(cdm = cdm, name = dplyr::starts_with(prefix)))
  if (!is.null(subsetCohort)) {
    omopgenerics::assertChoice(subsetCohort, names(cdm), call = call)
    subsetCohort <- omopgenerics::validateCohortArgument(cdm[[subsetCohort]])
    subsetCohortId <- omopgenerics::validateCohortIdArgument({{subsetCohortId}}, cohort = subsetCohort, call = call)
    x <- subsetCohort |>
      dplyr::filter(.data$cohort_definition_id %in% .env$subsetCohortId) |>
      dplyr::rename(person_id = "subject_id") |>
      dplyr::distinct(.data$person_id) |>
      dplyr::compute(name = omopgenerics::uniqueTableName(prefix = prefix))
  } else {
    x <- NULL
  }

  # get records
  nm <- omopgenerics::uniqueTableName(prefix = prefix)
  records <- recipeRecords(
    cdm = cdm,
    recipe = recipe,
    conceptSet = conceptSet,
    x = x,
    inObservation = TRUE,
    indexDate = NULL,
    censorDate = NULL
  ) |>
    dplyr::compute(name = nm)

  # erafy
  records <- OmopConstructor::collapseRecords(
    x = records,
    startDate = "cohort_start_date",
    endDate = "cohort_end_date",
    by = c("recipe", "subject_id"),
    name = nm
  )

  # combine records
  records <- combineRecords(records)

  # settings
  set <- dplyr::tibble(
    cohort_definition_id = seq_along(recipes),
    cohort_name = recipes,
    recipe = recipe
  ) |>
    dplyr::mutate(recipe = dplyr::if_else(
      .data$recipe %in% !!availableRecipes(),
      .data$recipe,
      NA_character_
    ))

  # attrition

  # codelists
  codelists <- codelistAttribute(conceptSet, recipe, set)

  # cohort
  nm <- omopgenerics::uniqueTableName(prefix = prefix)
  cdm <- omopgenerics::insertTable(
    cdm = cdm,
    name = nm,
    table = set |>
      dplyr::select("cohort_definition_id", recipe = "cohort_name")
  )
  cdm[[name]] <- records |>
    dplyr::inner_join(cdm[[nm]], by = "recipe") |>
    dplyr::select(!"recipe") |>
    dplyr::compute(name = name) |>
    omopgenerics::newCohortTable(
      cohortSetRef = set,
      cohortAttritionRef = NULL,
      cohortCodelistRef = codelists
    )

  return(cdm[[name]])
}

addRecipe <- function(x,
                      recipe,
                      conceptSet,
                      value,
                      window,
                      indexDate,
                      censorDate,
                      order,
                      nameStyle,
                      name,
                      call = parent.frame()) {
  # initial checks

  # prepare censorDate

  # get records

  # combine records

  # intersection
}

recipeRecords <- function(cdm,
                          recipe,
                          conceptSet,
                          inObservation,
                          prefix,
                          x = NULL) {
  if (!is.null(x)) {
    xid <- omopgenerics::getPersonIdentifier(x = x)
    x <- x |>
      dplyr::select(dplyr::all_of(c("subject_id" = xid))) |>
      dplyr::distinct() |>
      dplyr::mutate()
    CohortConstructor::addCohortTableIndex()
  }
  # subject_id, recipe, cohort_start_date, cohort_end_date, indexDate, censorDate

  if (inObservation) {
    records <- records |>
      PatientProfiles::filterInObservation(indexDate = "cohort_start_date")
  }
}
