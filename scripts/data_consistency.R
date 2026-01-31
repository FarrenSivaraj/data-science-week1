penguins_clean_names <- readRDS(url("https://github.com/UEABIO/5023B/raw/refs/heads/2026/files/penguins.RDS"))

# Check ranges of all numeric variables at once
penguins_clean_names |> 
  summarise(across(where(is.numeric), 
                   list(min = ~min(., na.rm = TRUE),
                        max = ~max(., na.rm = TRUE))))

# Check body mass range
penguins_clean_names |> 
  summarise(
    min_mass = min(body_mass_g, na.rm = TRUE),
    max_mass = max(body_mass_g, na.rm = TRUE)
  )

# Check for negative values (impossible for mass, length measurements)
minus_check <- penguins_clean_names |> 
  filter(if_any(c(body_mass_g, flipper_length_mm, 
                  culmen_length_mm, culmen_depth_mm), 
                ~ . < 0))
view(minus_check)

# Check for zero or negative values where zero doesn't make biological sense
zero_check <- penguins_clean_names |> 
  filter(body_mass_g <= 0)
view(zero_check)

# used view to make the result easier to see, seems there are no negatives or zeros

# Body mass ranges by species
penguins_clean_names |> 
  group_by(species) |> 
  summarise(
    min_mass = min(body_mass_g, na.rm = TRUE),
    max_mass = max(body_mass_g, na.rm = TRUE),
    mean_mass = mean(body_mass_g, na.rm = TRUE)
  )

# Find Adelie penguins with Gentoo-sized body mass
penguins_clean_names |> 
  filter(species == "Adelie", body_mass_g > 4750) 
# relying on scientific information not within the dataset to find errors in the data
# error in code, no latin name use within dataset, only abreviated/shortened name

# boxplot visualisation of data
penguins_clean_names |> 
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.2, alpha = 0.3) +
  labs(
    x = "",
    y = "Body mass (g)"
  ) +
  theme_minimal()+
  coord_flip()

#| label: fig-mass-flipper
#| fig-cap: "Body mass should generally increase with flipper length within species. Points far from the trend may indicate measurement errors."

penguins_clean_names |> 
  ggplot(aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(alpha = 0.6) +
  labs(
    x = "Flipper length (mm)",
    y = "Body mass (g)",
  ) +
  theme_minimal()

# Find penguins with large flippers but low body mass
penguins_clean_names |> 
  filter(flipper_length_mm > 210, body_mass_g < 3500) |> 
  select(species, sex, flipper_length_mm, body_mass_g, island)

# Find penguins with small flippers but high body mass
penguins_clean_names |> 
  filter(flipper_length_mm < 185, body_mass_g > 4500) |> 
  select(species, sex, flipper_length_mm, body_mass_g, island) # one penguin
# Legitimate individual variation is possible though

# Males cannot lay eggs
penguins_clean_names |> 
  filter(sex == "Male", !is.na(date_egg)) |> # error, MALE, should be: 'Male'
  select(species, sex, date_egg, body_mass_g, island)

# Check which species appear on which islands
penguins_clean_names |> 
  count(species, island) |> 
  pivot_wider(names_from = island, values_from = n, values_fill = 0)

# Flagging issues----

# Create flags for different types of potential issues
penguins_flagged <- penguins_clean_names |> 
  mutate(
    # Single-variable flags
    flag_impossible = case_when(
      body_mass_g <= 0 ~ "negative_or_zero_mass",
      flipper_length_mm <= 0 ~ "negative_or_zero_flipper",
      TRUE ~ NA_character_
    ),
    flag_implausible = case_when(
      body_mass_g < 2000 ~ "suspiciously_light",
      body_mass_g > 7000 ~ "suspiciously_heavy",
      TRUE ~ NA_character_
    ),
    
    # Cross-variable flags
    flag_species_size = case_when(
      #species == "Adelie" & body_mass_g > 5000 ~ "Adelie_too_heavy",
      species == "Gentoo" & body_mass_g < 4000 ~ "Gentoo_too_light",
      TRUE ~ NA_character_
    ),
    # Any flag present?
    any_flag = !is.na(flag_impossible) | !is.na(flag_implausible) | 
      !is.na(flag_species_size) 
  )

# Summarize flagged observations
penguins_flagged |> 
  summarise(
    n_impossible = sum(!is.na(flag_impossible)),
    n_implausible = sum(!is.na(flag_implausible)),
    n_species_size = sum(!is.na(flag_species_size)),
    total_flagged = sum(any_flag)
  )
# one flag for species size, removed too heavy to find cause
# cause is gentoo too light.

penguins_clean_names |> 
  filter(species == "Gentoo", body_mass_g < 4000) |> 
  select(species, sex, flipper_length_mm, body_mass_g, island)

#______________----