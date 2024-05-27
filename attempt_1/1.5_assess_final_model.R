# Regression Prediction Problem
# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load data
load(here("attempt_1/results/final_fit.rda"))
load(here("data/test_regression.rda"))

# predict from enet
regression_predict_en_1 <- final_fit |>
  predict(new_data = test_regression) |> 
  bind_cols(test_regression |> select(id)) |> 
  mutate(id = id, predicted = .pred) |> 
  select(id, predicted) 

# making submission
write_csv(regression_predict_en_1, file = here("attempt_1/submission/en_submission_attempt_1.csv"))