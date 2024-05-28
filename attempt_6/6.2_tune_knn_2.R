# Regression Prodiction Problem
# Nearest Neighbors 2

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# load training data
load(here("data/folds_regression.rda"))
load(here("data/train_regression.rda"))

# load pre-processing/feature engineering/recipe
load(here("attempt_6/results/regression_recipe_3.rda"))

# use parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# set seed
set.seed(1246810)

# model specifications ----
knn_mod <- nearest_neighbor(neighbors = tune()) |> 
  set_engine("kknn") |> 
  set_mode("regression")

# define workflows ----
wflow_knn_2 <- workflow() |> 
  add_model(knn_mod) |> 
  add_recipe(regression_recipe_3)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(knn_mod)

# change hyperparameter ranges
knn_params <- parameters(knn_mod)

# build tuning grid
knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflows/models ----
# set seed
set.seed(20243012)

# tune model
tune_knn_2 <- 
  wflow_knn_2 |> 
  tune_grid(
    folds_regression, 
    grid = knn_grid, 
    control = control_grid(save_workflow = TRUE),
    metrics = metric_set(mae)
  )

# write out results (fitted/trained workflows) ----
save(wflow_knn_2, file = here("attempt_6/results/wflow_knn_2.rda"))
save(tune_knn_2, file = here("attempt_6/results/tune_knn_2.rda"))