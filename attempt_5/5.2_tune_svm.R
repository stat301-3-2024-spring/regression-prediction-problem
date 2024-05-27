# Regression Prodiction Problem
# Define and fit elastic net

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# load training data
load(here("data/folds_regression.rda"))
load(here("data/train_regression.rda"))

# load pre-processing/feature engineering/recipe
load(here("attempt_5/results/regression_recipe_1.rda"))

# use parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# Define the metric set with MAE
metrics <- metric_set(rmse, rsq, mae)

# model specification ----
svm_spec <-
  svm_rbf(
    cost = tune(),
    rbf_sigma = tune()
  ) |>
  set_mode("regression") |>
  set_engine("kernlab")

# check tuning parameters
hardhat::extract_parameter_set_dials(svm_spec)

# set-up tuning grid ----
svm_params <- hardhat::extract_parameter_set_dials(svm_spec)

# define grid
svm_grid <- grid_regular(svm_params, levels = 5)

# workflow ----
svm_wflow <-
  workflow() |>
  add_model(svm_spec) |>
  add_recipe(regression_recipe_1)

# Tuning/fitting ----
svm_tune_1 <-
  svm_wflow |>
  tune_grid(
    resamples = folds_regression,
    grid = svm_grid,
    control = stacks::control_stack_grid(),
    metrics = metric_set(mae)
  )

# write out results (fitted/trained workflows) ----
save(svm_wflow, file = here("attempt_5/results/svm_wflow.rda"))
save(svm_tune_1, file = here("attempt_5/results/svm_tune_1.rda"))