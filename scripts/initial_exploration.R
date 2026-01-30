# Week 1: Initial Data Exploration ====
# Author: [Farren Sivaraj]
# Date: [30/01/2026]

# Load packages ====
library(tidyverse)
library(here)
library(naniar)
library(janitor)
library(skimr)
# Load data ====
mosquito_egg_raw <- read_csv(here("data", "mosquito_egg_data.csv"),
                             name_repair = janitor::make_clean_names)

# Basic overview ====
glimpse(mosquito_egg_raw)
summary(mosquito_egg_raw)
skim(mosquito_egg_raw)

# React table====
# view interactive table of data
view(mosquito_egg_raw)


# Counts by site and treatment====

mosquito_egg_raw |> 
  group_by(site, treatment) |> 
  summarise(n = n())

# Observations ====
# Your observations (add as comments below):
# - What biological system is this?
#    animal species that lays eggs
# - What's being measured?
#   changes in offspring/ eggs laid under different conditions
# - How many observations?
#   205 rows, 9 columns
# - Anything surprising?
#   hard to say, histogram for age days is surprisingly flat. Histogram for eggs is skewed to the left
# - Any obvious problems?
#   NAs, different case for the same factors, negative body mass