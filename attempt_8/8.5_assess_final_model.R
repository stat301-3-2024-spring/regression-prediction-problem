# Regression Prediction Problem
# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load data
load(here("attempt_8/results/final_fit_8.rda"))
load(here("data/test_regression.rda"))

# predict from bt
regression_predict_bt_8 <- final_fit_8 |>
  predict(new_data = test_regression) |> 
  bind_cols(test_regression |> select(id)) |> 
  mutate(id = id, predicted = .pred) |> 
  select(id, predicted)


# making submission
write_csv(regression_predict_bt_8, file = here("attempt_8/submission/knn_submission_attempt_8.csv"))