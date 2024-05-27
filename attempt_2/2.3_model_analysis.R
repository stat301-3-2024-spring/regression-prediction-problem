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
load(here("attempt_2/results/btree_tuned_1.rda"))

# creating individual tables 

tbl_bt_1 <- show_best(btree_tuned_1, metric = "mae") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Boosted Tree")

# save results table
save(tbl_bt_1, file = here("attempt_2/results/results_table.rda"))
