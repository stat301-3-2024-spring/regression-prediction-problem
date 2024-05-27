# Regression Prediction Problem
# Linear Model

## load packages ----

library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
load(here('data/folds_regression.rda'))

# Define the metric set with MAE
metrics <- metric_set(rmse, rsq, mae)

# model specifications ----
lm_mod <- linear_reg() |>
  set_engine("lm") |>
  set_mode("regression")

# define workflows ----
lm_wflow <-
  workflow() |> 
  add_model(lm_mod) |> 
  add_recipe(regression_recipe_1) 

# fit workflows/models ----
lm_fit_1 <- fit_resamples(lm_wflow, resamples = folds_regression, metrics = metric_set(mae),
                                        control = control_resamples(save_pred = TRUE))
                          
# view results
lm_results_1 <- lm_fit_1 |> collect_metrics()

# write out results (fitted/trained workflows) ----
save(lm_fit_1, file = here("attempt_1/results/lm_fit_1.rda"))