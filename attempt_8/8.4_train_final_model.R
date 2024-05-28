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
load(here("attempt_8/results/knn_tuned_8.rda"))
load(here("data/train_regression.rda"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# best model
# train whole training set on this model
# finalize workflow ----
final_wflow_8 <- knn_tuned_8 |> 
  extract_workflow(knn_tuned_8) |>  
  finalize_workflow(select_best(knn_tuned_8, metric = "mae"))

# train final model ----
# set seed
set.seed(20243012)
final_fit_8 <- fit(final_wflow_8, train_regression)

# save results
save(final_fit_8, file = "attempt_8/results/final_fit_8.rda")
save(final_wflow_8, file = "attempt_8/results/final_wflow_8.rda")