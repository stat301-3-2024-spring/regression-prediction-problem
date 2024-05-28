# Regression Prediction Problem ----
  # Define and tune first random forest model
  
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

# model specifications ----
rf_mod <-
  rand_forest(trees = tune(),
              min_n = tune(),
              mtry = tune()) |> 
  set_engine("ranger", importance = "impurity") |> 
  set_mode("regression")

# define workflows ----
# using basic tree recipe
rf_wflow_8 <- workflow() |> 
  add_model(rf_mod) |> 
  add_recipe(regression_recipe_5_tree)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_mod)

# change hyperparameter ranges
rf_params <- parameters(rf_mod) |> 
  update(mtry = mtry(c(1, 40)),
         trees = trees(range = c(1000, 2000)))

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

# fit workflows/models ----
# set seed
set.seed(1234)

# tune model
rf_tuned_8 <- 
  rf_wflow_8 |> 
  tune_grid(
    folds_regression, 
    grid = rf_grid, 
    control = stacks::control_stack_grid(),
    metrics = metric_set(mae)
  )

# looking at results
rf_results_8 <- rf_tuned_8 |> 
  collect_metrics()

# write out results (fitted/trained workflows) ----
save(rf_wflow_8, file = here("attempt_8/results/rf_wflow_2.rda"))
save(rf_tuned_8, file = here("attempt_8/results/rf_tuned_2.rda"))
save(rf_results_8, file = here("attempt_8/results/rf_results_2.rda"))