# Regression Prediction Problem
# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load data
load(here("attempt_5/results/final_fit_5.rda"))
load(here("data/test_regression.rda"))

# predict from enet
regression_predict_svm_1 <- final_fit_5 |>
  predict(new_data = test_regression) |> 
  bind_cols(test_regression |> select(id)) |> 
  mutate(id = id, predicted = .pred) |> 
  select(id, predicted) 

# making submission
write_csv(regression_predict_svm_1, file = here("attempt_5/submission/svm_submission_attempt_.csv"))