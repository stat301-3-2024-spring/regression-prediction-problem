# Regression Prediction Problem
# Recipes

## load packages ----

library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data/train_regression_new.rda"))

# creating kitchen sink recipe ----
regression_recipe_4 <- recipe(price ~., data = train_regression_new) |> 
  step_rm(first_review, last_review, review_scores_cleanliness, review_scores_communication, reviews_per_month, 
          review_scores_rating, review_scores_accuracy, review_scores_checkin, review_scores_location, 
          review_scores_value, host_location, host_neighbourhood, id, first_review, last_review) |> 
  # getting rid of all the variables that have more than 10% missingness
  # getting rid of id and date variables
  step_impute_mode(all_nominal_predictors()) |>
  step_impute_median(all_numeric_predictors()) |>
  step_novel(all_nominal_predictors()) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) 


# seeing if recipe works
regression_recipe_4_check <- prep(regression_recipe_4) |>
  bake(new_data = NULL)

save(regression_recipe_4, file = here('attempt_7/results/regression_recipe_4.rda'))