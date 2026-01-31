penguins_clean_names <- readRDS(url("https://github.com/UEABIO/5023B/raw/refs/heads/2026/files/penguins.RDS"))

view(penguins_clean_names)

# Trim white-space on either side of a string
library(tidyverse)
str_trim(" Adelie Penguin (Pygoscelis adeliae) ")

view(penguins_clean_names)

# Trim white-space on one side of a string
str_trim("  Adelie Penguin (Pygoscelis adeliae)  ", side = "left")

# leaves only extra spaces
str_squish("  Adelie    Penguin   (Pygoscelis   adeliae)  ")

# shorten long strings to a specific width 
str_trunc("Adelie Penguin (Pygoscelis adeliae)", width = 18, side = "right")

#split into smaller pieces
str_split("Adelie Penguin (Pygoscelis adeliae)", " ")

# Join text as one string
str_c("Adelie", "Penguin", sep = "_")

# Print only unique character strings in this variable
penguins_clean_names |>  
  distinct(sex)

# use mutate and case_when 
# for a statement that conditionally changes 
# the names of the values in a variable
penguins <- penguins_clean_names |> 
  mutate(species = case_when(
    species == "Adelie Penguin (Pygoscelis adeliae)" ~ "Adelie",
    species == "Gentoo penguin (Pygoscelis papua)" ~ "Gentoo",
    species == "Chinstrap penguin (Pygoscelis antarctica)" ~ "Chinstrap",
    .default = as.character(species)
  )
  )

# use mutate and if_else
# for a statement that conditionally changes 
# the names of the values in a variable
penguins <- penguins_clean_names |> 
  mutate(sex = if_else(
    sex == "MALE", "Male", "Female"
  )
  )

# use mutate and case_when 
# for a statement that conditionally changes 
# the names of the values in a variable
penguins_clean_names |> 
  mutate(species = stringr::word(species, 1)
  ) |> 
  mutate(sex = stringr::str_to_title(sex))

# own work, change all species names to uppercase
str_to_upper(penguins_clean_names$species)
head(penguins_clean_names)

# does not work, because there is no latin in the file
# using regex for name simplifying. But LLMs are good for building complex snippets
penguins_clean_names |> 
  separate(
    species,
    into = c("species", "full_latin_name"),
    sep = "(?=\\()"
  ) 

view(penguins_clean_names)

# used to filter data
str_detect("Genus specificus", "Genus")

# 3 possible names in species column
penguins_clean_names |> distinct(species)

penguins_clean_names |>
  filter(str_detect(species, "papua")) |>
  select(species)

# remove match for Genus (followed by a whitespace)
str_remove("Genus specificus", pattern = "Genus ")

#strip the brackets
penguins_clean_names |> 
  separate(
    species,
    into = c("species", "full_latin_name"),
    sep = "(?=\\()" # regex pattern: split before the '('
  ) |> 
  mutate(full_latin_name = str_remove_all(full_latin_name, "[\\(\\)]"))





