# Regression Prediction Problem
# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load data
load(here("attempt_3/results/final_fit.rda"))
load(here("data/test_regression.rda"))

# predict from bt
regression_predict_rf_3 <- final_fit_3 |>
  predict(new_data = test_regression) |> 
  bind_cols(test_regression |> select(id)) |> 
  mutate(id = id, predicted = .pred) |> 
  select(id, predicted)


# making submission
write_csv(regression_predict_rf_3, file = here("attempt_3/submission/rf_submission_attempt_3.csv"))