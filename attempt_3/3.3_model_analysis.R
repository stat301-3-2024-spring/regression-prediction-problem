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
load(here("attempt_3/results/tuned_rf_1.rda"))

# creating individual tables 

tbl_rf_1 <- show_best(tuned_rf_1, metric = "mae") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Random Forest")

# save results table
save(tbl_rf_1, file = here("attempt_3/results/results_table.rda"))
