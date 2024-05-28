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
load(here("attempt_6/results/tune_knn_2.rda"))

# creating individual tables 

tbl_knn_2 <- show_best(tune_knn_2, metric = "mae") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Nearest Neighbors")

# save results table
save(tbl_knn_2, file = here("attempt_6/results/results_table_6.rda"))
