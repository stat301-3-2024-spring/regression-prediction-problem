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
load(here("attempt_5/results/svm_tune_1.rda"))

# creating individual tables 

tbl_svm_1 <- show_best(svm_tune_1, metric = "mae") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "SVM")

# save results table
save(tbl_svm_1, file = here("attempt_5/results/results_table.rda"))
