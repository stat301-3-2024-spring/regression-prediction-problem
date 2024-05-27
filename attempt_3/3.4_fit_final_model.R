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
load(here("attempt_3/results/tuned_rf_1.rda"))
load(here("data/train_regression.rda"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# best model
# train whole training set on this model
# finalize workflow ----
final_wflow_3 <- tuned_rf_1 |> 
  extract_workflow(tuned_rf_1) |>  
  finalize_workflow(select_best(tuned_rf_1, metric = "mae"))

# train final model ----
# set seed
set.seed(20243012)
final_fit_3 <- fit(final_wflow_3, train_regression)

# save results
save(final_fit_3, file = "attempt_3/results/final_fit.rda")
save(final_wflow_3, file = "attempt_3/results/final_wflow.rda")