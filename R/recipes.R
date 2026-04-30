#' Title
#'
#' @param cdm
#' @param name
#' @param recipe
#' @param conceptSet
#' @param subsetCohort
#' @param subsetCohortId
#'
#' @returns
#' @export
#'
#' @examples
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
    subsetCohortId = subsetCohortId
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

  # records

  # set end date

  # combine records

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

}

recipeRecords <- function(cdm,
                          recipe,
                          conceptSet,
                          value,
                          x = NULL,
                          indexDate = NULL,
                          censorDate = NULL) {

}
