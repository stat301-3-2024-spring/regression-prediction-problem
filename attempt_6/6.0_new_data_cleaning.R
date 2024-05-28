# Regression Prediction Problem ----
# Data cleaning/wrangling for regression prediction problem

# load packages
library(tidyverse)
library(tidymodels)
library(here)
library(knitr)
library(naniar)

# cleaning for training data
train_regression_new <- train_regression |>
  mutate(host_response_rate = str_remove(host_response_rate, "%") |>
           as.numeric()/100,
         host_acceptance_rate = str_remove(host_acceptance_rate, "%") |>
           as.numeric()/100, 
         host_is_superhost = factor(host_is_superhost),
         host_has_profile_pic = factor(host_has_profile_pic),
         host_identity_verified = factor(host_identity_verified),
         has_availability = factor(has_availability),
         instant_bookable = factor(instant_bookable),
         host_since = as.Date(host_since),
         time_hosting = as.numeric(today() - host_since),
         price = str_remove(price, "\\$") |> str_remove(",") |> as.numeric(),
         across(where(is.character), as.factor)) |>
  select(-host_since)

# cleaning for testing data
test_regression_new <- test_regression |>
  mutate(host_response_rate = str_remove(host_response_rate, "%") |>
           as.numeric()/100,
         host_acceptance_rate = str_remove(host_acceptance_rate, "%") |>
           as.numeric()/100, 
         host_is_superhost = factor(host_is_superhost),
         host_has_profile_pic = factor(host_has_profile_pic),
         host_identity_verified = factor(host_identity_verified),
         has_availability = factor(has_availability),
         instant_bookable = factor(instant_bookable),
         host_since = as.Date(host_since),
         time_hosting = as.numeric(today() - host_since),
         across(where(is.character), as.factor)) |>
  select(-host_since)

# save out data
save(train_regression_new, file = here("data/train_regression_new.rda"))
save(test_regression_new, file = here("data/test_regression_new.rda"))