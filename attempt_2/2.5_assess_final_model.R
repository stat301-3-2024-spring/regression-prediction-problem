# Regression Prediction Problem
# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load data
load(here("attempt_2/results/final_fit.rda"))
load(here("data/test_regression.rda"))

# predict from bt
regression_predict_bt_2 <- final_fit |>
  predict(new_data = test_regression) |> 
  bind_cols(test_regression |> select(id)) |> 
  mutate(id = id, predicted = .pred) |> 
  select(id, predicted)


# making submission
write_csv(regression_predict_bt_2, file = here("attempt_2/submission/bt_submission_attempt_2.csv"))