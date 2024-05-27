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
load(here("attempt_5/results/svm_tune_1.rda"))
load(here("data/train_regression.rda"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# best model
# train whole training set on this model
# finalize workflow ----
final_wflow_5 <- svm_tune_1 |> 
  extract_workflow(svm_tune_1) |>  
  finalize_workflow(select_best(svm_tune_1, metric = "mae"))

# train final model ----
# set seed
set.seed(20243012)
final_fit_5 <- fit(final_wflow_5, train_regression)

# save results
save(final_fit_5, file = "attempt_5/results/final_fit_5.rda")
save(final_wflow_5, file = "attempt_5/results/final_wflow_5.rda")