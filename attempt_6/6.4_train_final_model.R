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
load(here("attempt_6/results/tune_knn_2.rda"))
load(here("data/train_regression_new.rda"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# best model
# train whole training set on this model
# finalize workflow ----
final_wflow_6 <- tune_knn_2 |> 
  extract_workflow(tune_knn_2) |>  
  finalize_workflow(select_best(tune_knn_2, metric = "mae"))

# train final model ----
# set seed
set.seed(20243012)
final_fit_6 <- fit(final_wflow_6, train_regression_new)

# save results
save(final_fit_6, file = "attempt_6/results/final_fit_6.rda")
save(final_wflow_6, file = "attempt_6/results/final_wflow_6.rda")