# Regression Prediction Problem
# Analysis of trained models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load in data and folds
load(here("data/folds_regression.rda"))
load(here("attempt_1/results/lm_fit_1.rda"))
load(here("attempt_1/results/tune_en_1.rda"))

# creating individual tables 

tbl_lm_1 <- show_best(lm_fit_1, metric = "mae") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Linear")

tbl_en_1 <- show_best(tune_en_1, metric = "mae") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Elastic Net")

# combining tables

results_table <- bind_rows(tbl_lm_1, tbl_en_1) |>
  arrange(mean)

view(results_table)

# save results table
save(results_table, file = here("attempt_1/results/results_table.rda"))
