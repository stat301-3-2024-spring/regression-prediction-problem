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
load(here("attempt_2/results/btree_tuned_1.rda"))
load(here("data/train_regression.rda"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# best model
# train whole training set on this model
# finalize workflow ----
final_wflow <- btree_tuned_1 |> 
  extract_workflow(btree_tuned_1) |>  
  finalize_workflow(select_best(btree_tuned_1, metric = "mae"))

# train final model ----
# set seed
set.seed(20243012)
final_fit <- fit(final_wflow, train_regression)

# save results
save(final_fit, file = "attempt_2/results/final_fit.rda")
save(final_wflow, file = "attempt_2/results/final_wflow.rda")