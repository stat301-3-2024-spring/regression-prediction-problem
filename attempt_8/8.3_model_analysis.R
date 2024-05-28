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
load(here("attempt_8/results/knn_tuned_8.rda"))
load(here("attempt_8/results/btree_tuned_8.rda"))

# creating individual tables 

tbl_knn_8 <- show_best(knn_tuned_8, metric = "mae") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN")

tbl_bt_8 <- show_best(btree_tuned_8, metric = "mae") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "BTree")

# combining tables

results_table_8 <- bind_rows(tbl_knn_8, tbl_bt_8) |>
  arrange(mean)

view(results_table_8)

# save results table
save(results_table_8, file = here("attempt_8/results/results_table_8.rda"))
