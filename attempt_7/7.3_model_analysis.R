# Regression Prediction Problem
# Analysis of trained models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load in data and folds
load(here("data/folds_regression_new.rda"))
load(here("attempt_7/results/btree_tuned_2.rda"))

# creating individual tables 

tbl_bt_2 <- show_best(btree_tuned_2, metric = "mae") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Boosted Tree 2")

# save results table
save(tbl_bt_2, file = here("attempt_7/results/results_table.rda"))
