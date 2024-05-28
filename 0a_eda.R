# Regression Prediction Problem
# EDA

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)
library(naniar)
library(kableExtra)
library(corrplot)

# handle common conflicts
tidymodels_prefer()

# load data ----
train_regression <- read_csv(here("data/train_regression.csv"), col_types = cols(id = col_character()))
test_regression <- read_csv(here("data/test_regression.csv"), col_types = cols(id = col_character()))

# check missingness
missingness <- train_regression |>  miss_var_summary() 

#  data with unacceptable missingness
#-first_review, -last_review, -review_scores_cleanliness, -review_scores_communication, -reviews_per_month, 
         #-review_scores_rating, -review_scores_accuracy, -review_scores_checkin, -review_scores_location, 
         #-review_scores_value, -host_location, -host_neighbourhood

# checking column types
str(train_regression)

# changing column types

train_regression <- train_regression |> 
  mutate(host_response_time = as.factor(host_response_time))

test_regression <- test_regression |> 
  mutate(host_response_time = as.factor(host_response_time))

train_regression <- train_regression |> 
  mutate(host_response_rate = parse_number(host_response_rate))

test_regression <- test_regression |> 
  mutate(host_response_rate = parse_number(host_response_rate))

train_regression <- train_regression |> 
  mutate(host_acceptance_rate = parse_number(host_acceptance_rate))

test_regression <- test_regression |> 
  mutate(host_acceptance_rate = parse_number(host_acceptance_rate))

levels_to_other <- c("Casa particular", "Entire home/apt", "Private room in tiny home", "Shared room in cabin")

train_regression <- train_regression |> 
  mutate(property_type = as.factor(property_type)) |> 
  mutate(property_type = fct_other(property_type, drop = levels_to_other, other_level = "other")) 

test_regression <- test_regression |> 
  mutate(property_type = as.factor(property_type)) |> 
  mutate(property_type = fct_other(property_type, drop = levels_to_other, other_level = "other"))

train_regression <- train_regression |> 
  mutate(room_type = as.factor(room_type))

test_regression <- test_regression |> 
  mutate(room_type = as.factor(room_type))

levels_to_other_bath <- c("0 shared baths", "7.5 baths", "8.5 baths")

train_regression <- train_regression |> 
  mutate(bathrooms_text = as.factor(bathrooms_text)) |> 
  mutate(bathrooms_text = fct_other(bathrooms_text, drop = levels_to_other_bath, other_level = "other"))

test_regression <- test_regression |> 
  mutate(bathrooms_text = as.factor(bathrooms_text)) |> 
  mutate(bathrooms_text = fct_other(bathrooms_text, drop = levels_to_other_bath, other_level = "other"))

train_regression <- train_regression |> 
  mutate(price = parse_number(price))

train_regression <- train_regression |>
  mutate_if(is.Date, as.character)

test_regression <- test_regression |>
  mutate_if(is.Date, as.character)

train_regression <- train_regression |>
  mutate_if(is.logical, as.character)

test_regression <- test_regression |>
  mutate_if(is.logical, as.character)

train_regression <- train_regression |> 
  mutate(host_is_superhost = as.factor(host_is_superhost))

test_regression <- test_regression |> 
  mutate(host_is_superhost = as.factor(host_is_superhost))

train_regression <- train_regression |> 
  mutate(host_has_profile_pic = as.factor(host_has_profile_pic))

test_regression <- test_regression |> 
  mutate(host_has_profile_pic = as.factor(host_has_profile_pic))

train_regression <- train_regression |> 
  mutate(host_identity_verified = as.factor(host_identity_verified))

test_regression <- test_regression |> 
  mutate(host_identity_verified = as.factor(host_identity_verified))

train_regression <- train_regression |> 
  mutate(has_availability = as.factor(has_availability))

test_regression <- test_regression |> 
  mutate(has_availability = as.factor(has_availability))

train_regression <- train_regression |> 
  mutate(instant_bookable = as.factor(instant_bookable))

test_regression <- test_regression |> 
  mutate(instant_bookable = as.factor(instant_bookable))


save(train_regression, file = here('data/train_regression.rda'))
save(test_regression, file = here('data/test_regression.rda'))

# determining correlations
target_column <- "price"

regression_correlations <- train_regression |> 
  select_if(is.numeric) 

correlation_matrix <- regression_correlations |> 
  select(all_of(target_column), everything()) |> 
  cor()

correlation_long <- as.data.frame(as.table(correlation_matrix))

view(correlation_matrix)
