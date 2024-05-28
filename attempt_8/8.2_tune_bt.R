# Regression Prediction Problem ----
# Define and tune first boosted tree model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load folds data
load(here("data/folds_regression.rda"))

# load pre-processing/feature engineering/recipe
load(here("attempt_8/results/regression_recipe_5_tree.rda"))

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
btree_wflow_8 <- workflow() |> 
  add_model(btree_mod) |> 
  add_recipe(regression_recipe_5_tree)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(btree_mod)

# change hyperparameter ranges
btree_params <- hardhat::extract_parameter_set_dials(btree_mod) |> 
  update(mtry = mtry(c(1, 25)),
         learn_rate = learn_rate(range = c(-0.2, -0.5)),
         trees = trees(range = c(1000, 2000)))

# build tuning grid
btree_grid <- grid_regular(btree_params, levels = c(5, 3, 4, 3))

# fit workflows/models ----
# set seed
set.seed(1234)
# tune model
btree_tuned_8 <- 
  btree_wflow_8 |> 
  tune_grid(
    folds_regression, 
    grid = btree_grid, 
    control = stacks::control_stack_grid(),
    metrics = metric_set(mae)
  )

# looking at results
btree_results_8 <- btree_tuned_8 |> 
  collect_metrics()

# write out results (fitted/trained workflows) ----
save(btree_wflow_8, file = here("attempt_8/results/btree_wflow_8.rda"))
save(btree_tuned_8, file = here("attempt_8/results/btree_tuned_8.rda"))
save(btree_results_8, file = here("attempt_8/results/btree_results_8.rda"))