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
#   NAs, different case for the same factors, negative body mass, more eggs hatched than laid

#  counting unique entries
mosquito_egg_raw |> 
  summarise(
    n = n(),
    n_distinct(female_id))

# Checking that the change in folder has not affected the github connection



# FIX 1: [Multiple names for the same distinct value e.g. differences in capitalization. fix misspelled names for both site and treatment] ====

# Show the problem:
mosquito_egg_raw |> distinct(collector,site,treatment)
mosquito_egg_raw |> distinct(site)
mosquito_egg_raw |> distinct(treatment)

# Fix it:
mosquito_egg_data_step1 <- mosquito_egg_raw |>
  # YOUR CODE HERE
  mutate(collector = case_when(collector == "Smyth" ~ "Smith", collector == "Garci" ~ "Garcia",.default = as.character(collector)),
         site = case_when(site == "Site C" ~ "Site_C", site == "Site-C" ~ "Site_C", site == "site_c" ~ "Site_C",
                          site == "site_a" ~ "Site_A",site == "Site-A" ~ "Site_A",site == "Site A" ~ "Site_A",
                          site == "site_b" ~ "Site_B",site == "Site-B" ~ "Site_B",site == "Site B" ~ "Site_B",.default = as.character(site)))

mosquito_egg_data_step1 <- mosquito_egg_data_step1 |>
  mutate(treatment = str_to_lower(treatment))
  
  # Verify it worked:
mosquito_egg_data_step1 |> distinct(collector)
mosquito_egg_data_step1 |> distinct(site)
mosquito_egg_data_step1 |> distinct(treatment)
  
  # What changed and why it matters:
  # [Changed the characters for different variable names that were 
  # likely to be misspellings of other names 
  # e.g. Garcia as Garci or Smith as Smyth corrections reduces error from 
  # splitting values into false groups, ensures values are stored 
  # under the proper distinct names]
  

  # FIX 2: [duplicates fo whole rows of data]  ====

# Show the problem:
mosquito_egg_data_step1 |> 
  get_dupes()

# Fix it:
mosquito_egg_data_step2 <- mosquito_egg_data_step1 |>
  # YOUR CODE
filter(!duplicated(across(everything())))
  
  # Verify it worked:
mosquito_egg_data_step2 |> 
  get_dupes()

  
  # What changed and why it matters:
  # [Removed completely identical rows. exact same values for all very unlikely, especially 
  # including date and body mass. Therefore, data will not be skewed by the duplicates]

