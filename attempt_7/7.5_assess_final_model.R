# Regression Prediction Problem
# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load data
load(here("attempt_7/results/final_fit_7.rda"))
load(here("data/test_regression_new.rda"))

# predict from bt
regression_predict_bt_7 <- final_fit_7 |>
  predict(new_data = test_regression_new) |> 
  bind_cols(test_regression_new |> select(id)) |> 
  mutate(id = id, predicted = .pred) |> 
  select(id, predicted)


# making submission
write_csv(regression_predict_bt_7, file = here("attempt_7/submission/bt_submission_attempt_7.csv"))