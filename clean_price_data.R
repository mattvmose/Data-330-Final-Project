# clean_price_data.R

library(readr)
library(dplyr)
library(stringr)

# Loading raw CSVs into R
amazon_raw <- read.csv("raw_price_data/raw_amazon_data.csv")
target_raw <- read.csv("raw_price_data/raw_target_data.csv")

# Normalizing Data Types
amazon_raw <- amazon_raw |> mutate(Product_Price = as.numeric(gsub("[^0-9\\.]", "", Product_Price)),
                                     Date = as.Date(Date, format="%Y-%m-%d"),
                                     Product_Name = str_remove(Product_Name, ",.*"))

target_raw <- target_raw |> mutate(Product_Price = as.numeric(Product_Price),
                                   Date = as.Date(Date, format="%Y-%m-%d"),
                                   Product_Name = str_trim(str_remove(Product_Name, " - .*|,.*")),
                                   Product_Name = str_replace_all(Product_Name, "&#39;", "'"))

# Creating lookup table to map walmart_raw products to target_raw products
lookup <- tibble(
  amazon_raw_names = c("Vital Farms", "Horizon Organic High Vitamin D Whole Milk", "Nature's Own Honey Wheat", "Kraft Singles American Slices", "Lemon", "Navel Orange", "Gala Apple", "Organic Roma Tomato", "Iceberg Lettuce"),
  target_raw_names = c("Vital Farms Pasture Raised Eggs", "Horizon Organic High Vitamin D Milk", "Nature's Own Honey Wheat Bread", "Kraft Singles American Cheese Slices", "Fresh Lemon", "Fresh Navel Orange", "Fresh Gala Apple", "Fresh Organic Roma Tomatoes", "Fresh Iceberg Lettuce Head")
)

# Applying lookup to target_raw
amazon_raw_clean <- amazon_raw |>
  left_join(lookup, by=c("Product_Name" = "amazon_raw_names")) |>
  mutate(Product_Name = coalesce(target_raw_names, Product_Name))

# Joining Walmart and Target Data
clean_data <- full_join(amazon_raw_clean, target_raw, by=c("Date", "Product_Name"))

clean_data <- clean_data |>
  rename(
    Date = Date,
    Amazon_Price = Product_Price.x,
    Target_Price = Product_Price.y,
  ) |>
  select(Date, Product_Name, Amazon_Price, Target_Price)

# Writing to CSV
output_file <- "clean_price_data/price_data.csv"
if(!dir.exists("clean_price_data")) {
  dir.create("clean_price_data")
}

write_csv(clean_data, output_file)
