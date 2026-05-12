
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
                          x,
                          name) {
  prefix <- omopgenerics::tmpPrefix()

  if (!is.null(x)) {
    xid <- omopgenerics::getPersonIdentifier(x = x)
    x <- x |>
      dplyr::select(dplyr::all_of(c("person_id" = xid))) |>
      dplyr::distinct() |>
      dplyr::compute(name = omopgenerics::uniqueTableName(prefix = prefix))
    CohortConstructor:::addIndex(x, cols = "person_id")
  }

  # get domains
  concepts <- dplyr::as_tibble(conceptSet)
  con <- omopgenerics::uniqueTableName(prefix = prefix)
  cdm <- omopgenerics::insertTable(cdm = cdm, name = con, table = concepts)
  cdm[[con]] <- cdm[[con]] |>
    dplyr::left_join(
      cdm$concept |>
        dplyr::select("concept_id", "domain_id"),
      by = "concept_id"
    ) |>
    dplyr::compute(name = con)

  # supportedDomains
  domains <- supportedDomains(cdm[[con]])

  if (length(domains) == 0) {
    records <- cdm$person |>
      dplyr::select("subject_id" = "person_id") |>
      utils::head(0) |>
      dplyr::mutate(
        concept_name = NA_character_,
        cohort_start_date = as.Date(NA_character_),
        cohort_end_date = as.Date(NA_character_)
      ) |>
      dplyr::compute(name = name)
  } else {
    records <- domains |>
      purrr::map(\(dom) {

        # get table
        table <- tableDomain(domain = dom)
        if (!table %in% names(cdm)) {
          cli::cli_inform(c("!" = "Skipping {.pkg {table}} as not present in the cdm."))
          return(NULL)
        }
        concept <- omopgenerics::omopColumns(table = table, field = "standard_concept_id")
        startDate <- omopgenerics::omopColumns(table = table, field = "start_date")
        endDate <- omopgenerics::omopColumns(table = table, field = "end_date")

        # add indexes
        nm1 <- omopgenerics::uniqueTableName(prefix = prefix)
        cdm[[nm1]] <- cdm[[con]] |>
          dplyr::filter(.data$domain_id == .env$dom) |>
          dplyr::select(!!concept := "concept_id", "codelist_name") |>
          dplyr::compute(name = nm1)
        CohortConstructor:::addIndex(cdm[[nm1]], cols = "person_id")

        # get records
        rec <- cdm[[table]] |>
          dplyr::inner_join(cdm[[nm1]], by = concept)
        if (identical(startDate, endDate)) {
          rec <- rec |>
            dplyr::select(dplyr::any_of(c(
              "codelist_name", "subject_id" = "person_id",
              "cohort_start_date" = startDate,
              "value_as_number", "value_as_concept_id", "unit_concept_id"
            ))) |>
            dplyr::mutate(cohort_end_date = .data$cohort_start_date)
        } else {
          rec <- rec |>
            dplyr::select(dplyr::any_of(c(
              "codelist_name", "subject_id" = "person_id",
              "cohort_start_date" = startDate, "cohort_end_date" = endDate,
              "value_as_number", "value_as_concept_id", "unit_concept_id"
            ))) |>
            dplyr::mutate(cohort_end_date = dplyr::coalesce(.data$cohort_end_date, .data$cohort_start_date))
        }
        if (inObservation) {
          rec <- rec |>
            PatientProfiles::filterInObservation(indexDate = "cohort_start_date")
        }
        rec <- rec |>
          dplyr::compute(name = omopgenerics::uniqueTableName(prefix = prefix))

        # subset to values of interest
        if (table %in% c("observation", "measurement")) {

        }

        # drop concept table
        omopgenerics::dropSourceTable(cdm = cdm, name = nm1)

        return(rec)
      }) |>
      purrr::compact()

    # combine all records
    records <- records |>
      purrr::reduce(dplyr::union_all) |>
      dplyr::select("codelist_name", "subject_id", "cohort_start_date", "cohort_end_date") |>
      dplyr::compute(name = name)
  }

  omopgenerics::dropSourceTable(cdm = cdm, name = dplyr::starts_with(prefix))

  return(records)
}
supportedDomains <- function(concepts) {
  domains <- concepts |>
    dplyr::group_by(.data$domain_id) |>
    dplyr::tally() |>
    dplyr::collect()
  supported <- c("Condition", "Device", "Drug", "Episode", "Measurement", "Observation", "Procedure", "Specimen", "Visit")
  eliminated <- domains |>
    dplyr::filter(!.data$domain_id %in% .env$supported)
  if (nrow(eliminated) > 0) {
    ne <- sum(eliminated$n)
    c("!" = "{ne} {.emph concepts} ignored as not part of supported domains: {.var {supported}}.") |>
      cli::cli_inform()
    domains <- domains |>
      dplyr::filter(.data$domain_id %in% .env$supported)
  }
  return(domains$domain_id)
}
tableDomain <- function(domain) {
  swicth(domain,
         "Condition" = "condition_occurrence",
         "Device" = "device_exposure",
         "Drug" = "drug_exposure",
         "Episode" = "episode",
         "Measurement" = "measurement",
         "Observation" = "observation",
         "Procedure" = "procedure_occurrence",
         "Specimen" = "specimen",
         "Visit" = "visit_occurrence")
}
insertConcepts <- function(concepts, cdm, nm) {

  cdm <- omopgenerics::insertTable(cdm = cdm, name = nm, table = concepts)
  col <- colnames(concepts)
  CohortConstructor:::addIndex(cdm[[nm]], cols = )
}
