# Regression Prodiction Problem
# Random Forest

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# load training data
load(here("data/folds_regression.rda"))
load(here("data/train_regression.rda"))

# load pre-processing/feature engineering/recipe
load(here("attempt_3/results/regression_recipe_2.rda"))

# set seed
set.seed(20243012)

# model specifications ----
rf_mod <-
  rand_forest(trees = 1000,
              min_n = tune(),
              mtry = tune()) |> 
  set_engine("ranger") |> 
  set_mode("regression")

# define workflows ----
wflow_rf_1 <- workflow() |> 
  add_model(rf_mod) |> 
  add_recipe(regression_recipe_2)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_mod)

# change hyperparameter ranges
rf_params <- parameters(rf_mod) |> 
  update(mtry = mtry(c(1, 56))) 

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

# fit workflows/models ----
# set seed
set.seed(20243012)

# tune model
tuned_rf_1 <- 
  wflow_rf_1 |> 
  tune_grid(
    folds_regression, 
    grid = rf_grid, 
    control = control_grid(save_workflow = TRUE),
    metrics = metric_set(mae)
  )

# write out results (fitted/trained workflows) ----
save(wflow_rf_1, file = here("attempt_3/results/wflow_rf_1.rda"))
save(tuned_rf_1, file = here("attempt_3/results/tuned_rf_1.rda"))