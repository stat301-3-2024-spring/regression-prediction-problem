# Regression Prediction Problem
# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load data
load(here("attempt_6/results/final_fit_6.rda"))
load(here("data/test_regression_new.rda"))

# predict from knn
regression_predict_knn_6 <- final_fit_6 |>
  predict(new_data = test_regression_new) |> 
  bind_cols(test_regression_new |> select(id)) |> 
  mutate(id = id, predicted = .pred) |> 
  select(id, predicted)


# making submission
write_csv(regression_predict_knn_6, file = here("attempt_6/submission/knn_submission_attempt_6.csv"))