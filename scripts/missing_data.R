penguins_clean_names <- readRDS(url("https://github.com/UEABIO/5023B/raw/refs/heads/2026/files/penguins.RDS"))
# error in the code, addition of ")) 

library(tidyverse)
penguins_clean_names |> 
  group_by(species) |> 
  summarise(mean = mean(body_mass_g))
# NA for both Adelie and Gentoo. does this indicate the presence of NAs?

# ways to find NAs easily. 
summary(penguins_clean_names)

library(skimr)
skimr::skim(penguins_clean_names)

# very nice visual representation of the missing values - helpful for finding the presence of useless rows
library(naniar)
naniar::vis_miss(penguins_clean_names)

# bar graph representation. Doesn't feel very useful compared to the last method. 
naniar::gg_miss_upset(penguins_clean_names)

view(penguins_clean_names)

# Returning all rows with missing values
penguins_clean_names |> 
  filter(if_any(everything(), is.na)) |>
  select(culmen_length_mm, culmen_depth_mm, flipper_length_mm, 
         sex, delta_15_n_o_oo, delta_13_c_o_oo,comments,
         everything()) # reorder columns
# row 4 is clearly useless, missing data appear to have no link to other variables, appears as MCAR

# look at a specific columns NAs
penguins_clean_names |> 
  filter(if_any(culmen_length_mm, is.na))  # reorder columns

# removes all NAs, but can lead to significant data loss. Can also work for specific variables, but should be done carefully and critically
#penguins_clean_names |> 
#  drop_na()

# removing NAs as needed within functions preserves the original data set
penguins_clean_names |> 
  group_by(species) |> 
  summarise(
    mean_body_mass = mean(body_mass_g, na.rm = T)
  )
# can cause problems with some analysis
