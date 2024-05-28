# Regression Prediction Problem
# Boosted Tree Model

## load packages ----

library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
load(here('data/folds_regression.rda'))
load(here('attempt_2/results/regression_recipe_2.rda'))

# Define the metric set with MAE
metrics <- metric_set(rmse, rsq, mae)

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# set seed
set.seed(1234)

# model specifications ----
btree_mod <- boost_tree(
  mtry = tune(),
  min_n = tune(),
  learn_rate = tune(),
  trees = tune()) |> 
  set_engine("xgboost") |> 
  set_mode("regression")

# define workflows ----
btree_wflow_1 <- workflow() |> 
  add_model(btree_mod) |> 
  add_recipe(regression_recipe_2)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(btree_mod)

# change hyperparameter ranges
btree_params <- hardhat::extract_parameter_set_dials(btree_mod) |> 
  update(mtry = mtry(c(1, 5)),
         learn_rate = learn_rate(range = c(-5, 0.2)),
         trees = trees(range = c(50, 500)))

# build tuning grid
btree_grid <- grid_regular(btree_params, levels = c(5, 3, 4, 5))

# fit workflows/models ----
# set seed
set.seed(1234)
# tune model
btree_tuned_1 <- 
  btree_wflow_1 |> 
  tune_grid(
    folds_regression, 
    grid = btree_grid, 
    control = control_grid(save_workflow = TRUE),
    metrics = metric_set(mae)
  )

# looking at results
btree_results_1 <- btree_tuned_1 |> 
  collect_metrics()

# write out results (fitted/trained workflows) ----
save(btree_wflow_1, file = here("attempt_2/results/btree_wflow_1.rda"))
save(btree_tuned_1, file = here("attempt_2/results/btree_tuned_1.rda"))
save(btree_results_1, file = here("attempt_2/results/btree_results_1.rda"))