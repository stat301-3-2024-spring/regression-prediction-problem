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
load(here("attempt_4/results/tune_knn_1.rda"))

# creating individual tables 

tbl_knn_1 <- show_best(tune_knn_1, metric = "mae") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Nearest Neighbors")

# save results table
save(tbl_knn_1, file = here("attempt_4/results/results_table.rda"))
