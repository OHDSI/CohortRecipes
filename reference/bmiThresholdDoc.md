# Helper for consistent documentation of `bmiThreshold` argument

Helper for consistent documentation of `bmiThreshold` argument

## Arguments

- bmiThreshold:

  Argument to indicate the thresholds for the obesity using BMI
  measurements. It can be:

  - A single number, any BMI measurement above the threshold will be
    consider as an obesity record.

  - A tibble with the columns `bmi_threshold`, `sex`, `age_min` and
    `age_max`, to use age and sex specific thresholds.

  - NULL the table
    [`CohortRecipes::bmiThreshold`](https://ohdsi.github.io/CohortRecipes/reference/bmiThreshold.md)
    will be used.
