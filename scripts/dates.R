penguins_clean_names <- readRDS(url("https://github.com/UEABIO/5023B/raw/refs/heads/2026/files/penguins.RDS"))

library(lubridate) # designed to help read information from dates
library(tidyverse)

# for dates, format is important:  ymd(), ydm(), mdy(), dmy()

date("2017-10-11T14:02:00")

dmy("11 October 2020")

mdy("10/11/2020")

# some formats can be difficult to read
df <- tibble(
  date = c("X2020.01.22",
           "X2020.01.22",
           "X2020.01.22",
           "X2020.01.22")
)

df |> 
  mutate(
    date = as_date(date)
  )

# therefore, we can use % to direct the function to the parts it needs to read
df |> 
  mutate(
    date = as_date(date, format = "X%Y.%m.%d")
  )

# specific parts can also be extracted
year("2017-11-28T14:02:00")

month("2017-11-28T14:02:00")

week("2017-11-28T14:02:00")

day("2017-11-28T14:02:00")
 
# excel stores dates as serial numbers, counting from an origin date. For windows, that's 1899-12-30
library(janitor)

excel_numeric_to_date(42370) # the janitor package has a function which can solve this

view(penguins_clean_names)

penguins_clean_names <- penguins_clean_names |>
  mutate(date_egg = lubridate::ymd(date_egg)) 
# original code was incorrect.Format of dataset was ymd, but question expected dmy


# find max and min date
penguins_clean_names |> 
  summarise(min_date=min(date_egg),
            max_date=max(date_egg))

# adding new column for year to the dataset
penguins_clean_names <- penguins_clean_names |> 
  mutate(year = lubridate::year(date_egg))

# return records after 2008
penguins_clean_names |>
  filter(date_egg >= ymd("2008-01-01"))
