# Classification Prediction Problem ----
# Define and tune first nearest neighbor model

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
knn_mod <- nearest_neighbor(neighbors = tune()) |> 
  set_engine("kknn") |> 
  set_mode("regression")

# define workflows ----
knn_wflow_8 <- workflow() |> 
  add_model(knn_mod) |> 
  add_recipe(regression_recipe_5_tree)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(knn_mod)

# change hyperparameter ranges
knn_params <- parameters(knn_mod)

# build tuning grid
knn_grid <- grid_latin_hypercube(knn_params, size = 50)

# fit workflows/models ----
# set seed
set.seed(1234)

# tune model
knn_tuned_8 <- 
  knn_wflow_8 |> 
  tune_grid(
    folds_regression, 
    grid = knn_grid, 
    control = stacks::control_stack_grid(),
    metrics = metric_set(mae)
  )

# looking at results
knn_results_8 <- knn_tuned_8 |> 
  collect_metrics()

# write out results (fitted/trained workflows) ----
save(knn_wflow_8, file = here("attempt_8/results/knn_wflow_8.rda"))
save(knn_tuned_8, file = here("attempt_8/results/knn_tuned_8.rda"))
save(knn_results_8, file = here("attempt_8/results/knn_results_8.rda"))
