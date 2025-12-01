# clean_price_data.R

library(readr)
library(dplyr)
library(stringr)

# Loading raw CSVs into R
safeway_raw <- read.csv("raw_price_data/raw_safeway_data.csv")
target_raw <- read.csv("raw_price_data/raw_target_data.csv")

# Normalizing Data Types
safeway_raw <- safeway_raw |> mutate(Product_Price = as.numeric(gsub("[^0-9\\.]", "", Product_Price)),
                                     Date = as.Date(Date, format="%Y-%m-%d"),
                                     Detail = c("Eggs", "Milk", "Sandwich Bread", "Sandwich Cheese", "Citrus_Lemon", "Citrus_Orange", "Apples", "Tomatoes", "Lettuce & Greens"))

target_raw <- target_raw |> mutate(Product_Price = as.numeric(Product_Price),
                                   Date = as.Date(Date, format="%Y-%m-%d"),
                                   Product_Name = str_trim(str_remove(Product_Name, " - .*|,.*")),
                                   Product_Name = str_replace_all(Product_Name, "&#39;", "'"))

# Creating lookup table to map walmart_raw products to target_raw products
lookup <- tibble(
  safeway_raw_names = c("Eggs", "Milk", "Sandwich Bread", "Sandwich Cheese", "Citrus_Lemon", "Citrus_Orange", "Apples", "Tomatoes", "Lettuce & Greens"),
  target_raw_names = c("Vital Farms Pasture Raised Eggs", "Horizon Organic High Vitamin D Milk", "Nature's Own Honey Wheat Bread", "Kraft Singles American Cheese Slices", "Fresh Lemon", "Fresh Navel Orange", "Fresh Gala Apple", "Fresh Organic Roma Tomatoes", "Fresh Iceberg Lettuce Head")
)

# Applying lookup to target_raw
safeway_raw_clean <- safeway_raw |>
  left_join(lookup, by=c("Detail" = "safeway_raw_names")) |>
  mutate(Product_Name = coalesce(target_raw_names, Product_Name))

# Joining Walmart and Target Data
clean_data <- full_join(safeway_raw_clean, target_raw, by=c("Date", "Product_Name"))

clean_data <- clean_data |>
  rename(
    Date = Date,
    Safeway_Price = Product_Price.x,
    Target_Price = Product_Price.y,
  ) |>
  select(Date, Product_Name, Safeway_Price, Target_Price)

# Writing to CSV
output_file <- "clean_price_data/price_data.csv"
if(!dir.exists("clean_price_data")) {
  dir.create("clean_price_data")
}

write_csv(clean_data, output_file)
