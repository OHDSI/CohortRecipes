# Create the obesity cohort

Create the obesity cohort

## Usage

``` r
obesityCohort(cdm, name, conceptSet = NULL, bmiThreshold = NULL)
```

## Arguments

- cdm:

  A `<cdm_reference>` object.

- name:

  A character string with the name of the new cohort.

- conceptSet:

  It can either be a , \<codelist_with_details\> or
  \<concept_set_expression\> object. It must contain `obesity`, `bmi` as
  concepts. If `NULL` concepts will be retrieved using the OmopConcepts
  package.

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

## Value

The cohort 'obesity' object.

## Examples

``` r
# \donttest{
library(CohortRecipes)
library(omock)

cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")
#> ℹ Loading bundled GiBleed tables from package data.
#> ℹ Adding drug_strength table.
#> ℹ Creating local <cdm_reference> object.
#> ℹ Inserting <cdm_reference> into duckdb.

cdm$obesity <- obesityCohort(cdm = cdm, name = "obesity")
#> ! `conceptSet` is `NULL`, the conceptSet will be downloaded using OmopConcepts
#> ℹ Set `options('omop.concepts.source' = 'OmopConcepts')` to silence this
#>   message.
#> ℹ Using internal bmiThreshold for BMI cut-offs.
#> ✖ Domain NA (85 concepts) excluded because it is not supported.
#> ℹ No cohort entries found, returning empty cohort table.

cdm$obesity
#> # Source:   table<results.test_obesity> [?? x 4]
#> # Database: DuckDB 1.5.2 [unknown@Linux 6.17.0-1010-azure:R 4.5.3//tmp/Rtmpwzbprc/file1b1f6371b99a.duckdb]
#> # ℹ 4 variables: cohort_definition_id <int>, subject_id <int>,
#> #   cohort_start_date <date>, cohort_end_date <date>

# }
```
