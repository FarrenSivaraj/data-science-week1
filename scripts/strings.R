penguins_clean_names <- readRDS(url("https://github.com/UEABIO/5023B/raw/refs/heads/2026/files/penguins.RDS"))

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