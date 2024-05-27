# Regression Prediction Problem
# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load data
load(here("attempt_4/results/final_fit.rda"))
load(here("data/test_regression.rda"))

# predict from bt
regression_predict_knn_4 <- final_fit_4 |>
  predict(new_data = test_regression) |> 
  bind_cols(test_regression |> select(id)) |> 
  mutate(id = id, predicted = .pred) |> 
  select(id, predicted)


# making submission
write_csv(regression_predict_knn_4, file = here("attempt_4/submission/knn_submission_attempt_4.csv"))