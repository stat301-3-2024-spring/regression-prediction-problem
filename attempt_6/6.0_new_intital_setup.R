# Regression Prediction Problem
# Initial Setup 2

# Initial data checks & data splitting

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
load(here('data/train_regression_new.rda'))
load(here("data/test_regression_new.rda"))


# setting a seed ----

set.seed(12468)

# set up controls for fitting resamples ----
folds_regression_new <- vfold_cv(train_regression_new, v = 5, repeats = 3,
                             strata = price)

# write out split, train, test and folds ----
save(folds_regression_new, file = here("data/folds_regression_new.rda"))