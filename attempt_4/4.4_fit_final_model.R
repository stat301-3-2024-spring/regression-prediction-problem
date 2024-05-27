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
load(here("attempt_4/results/tune_knn_1.rda"))
load(here("data/train_regression.rda"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# best model
# train whole training set on this model
# finalize workflow ----
final_wflow_4 <- tune_knn_1 |> 
  extract_workflow(tune_knn_1) |>  
  finalize_workflow(select_best(tune_knn_1, metric = "mae"))

# train final model ----
# set seed
set.seed(20243012)
final_fit_4 <- fit(final_wflow_4, train_regression)

# save results
save(final_fit_4, file = "attempt_4/results/final_fit.rda")
save(final_wflow_4, file = "attempt_4/results/final_wflow.rda")