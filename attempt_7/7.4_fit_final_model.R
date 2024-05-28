# Regression Prediction Problem
# Train final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doParallel)

# handle common conflicts
tidymodels_prefer()

# load necessary data ----
load(here("attempt_7/results/btree_tuned_2.rda"))
load(here("data/train_regression_new.rda"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# best model
# train whole training set on this model
# finalize workflow ----
final_wflow_7 <- btree_tuned_2 |> 
  extract_workflow(btree_tuned_2) |>  
  finalize_workflow(select_best(btree_tuned_2, metric = "mae"))

# train final model ----
# set seed
set.seed(20243012)
final_fit_7 <- fit(final_wflow_7, train_regression_new)

# save results
save(final_fit_7, file = "attempt_7/results/final_fit_7.rda")
save(final_wflow_7, file = "attempt_7/results/final_wflow_7.rda")