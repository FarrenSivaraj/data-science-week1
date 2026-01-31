penguins_clean_names <- readRDS(url("https://github.com/UEABIO/5023B/raw/refs/heads/2026/files/penguins.RDS"))

# 2 different methods for checking rows
library(tidyverse)
# check for whole duplicate 
# rows in the data
penguins_clean_names |> 
  filter(duplicated(across(everything()))) %>%
  sum() # this does not seem to be connected, nor work?

library(janitor)

penguins_clean_names |> 
  get_dupes()

# no duplicates found

# adding duplicates to the file
penguins_demo <- penguins_clean_names |> 
  slice(1:50) |> 
  bind_rows(slice(penguins_clean_names, c(1,5,10,15,30)))

# checking for the duplicates
penguins_demo |> 
  get_dupes()

penguins_demo |> 
  filter(duplicated(across(everything()))) %>%
  count() #problem is that if you pipe into sum, its isn't all numeric.
# using count instead seems to work well
 
# Keep only unduplicated data with !
penguins_demo |> 
  filter(!duplicated(across(everything())))

penguins_demo |> 
  distinct()

#  counting unique entries
penguins_clean_names |> 
  summarise(
    n = n(),
    n_distinct(individual_id)
  )




