# clean_price_data.R

library(readr)
library(dplyr)
library(stringr)

# Loading raw CSVs into R
walmart_raw <- read.csv("raw_price_data/raw_walmart_data.csv")
target_raw <- read.csv("raw_price_data/raw_target_data.csv")

# Normalizing Data Types
walmart_raw <- walmart_raw |> mutate(Product_Price = as.numeric(gsub("[^0-9\\.]", "", Product_Price)),
                                     Date = as.Date(Date, format="%Y-%m-%d"),
                                     Product_Size = str_extract(Product_Name, "\\d+\\s?(oz|fl oz|Ct|ct)|Each"),
                                     Product_Name = str_remove(Product_Name, ",.*"))

target_raw <- target_raw |> mutate(Product_Price = as.numeric(Product_Price),
                                   Date = as.Date(Date, format="%Y-%m-%d"),
                                   Product_Size = str_extract(Product_Name, "(\\d+\\s?(oz|lb|each))(/\\d+\\s?(ct|each))?|each"),
                                   Product_Name = str_trim(str_remove(Product_Name, " - .*|,.*")),
                                   Product_Name = str_replace_all(Product_Name, "&#39;", "'"))
target_raw[[4]][1] <- '12ct'
target_raw[[4]][2] <- '128oz'

# Creating lookup table to map walmart_raw products to target_raw products
lookup <- tibble(
  walmart_raw_names = c("Vital Farms Pasture Raised Grade A Brown Eggs", "Horizon Organic High Vitamin D Whole Milk", "Nature's Own Honey Wheat Sandwich Bread Loaf", "Kraft Singles American Slices", "Fresh Lemon", "Fresh Navel Orange", "Fresh Gala Apple", "Fresh Roma Tomato", "Fresh Iceberg Lettuce"),
  target_raw_names = c("Vital Farms Pasture Raised Eggs", "Horizon Organic High Vitamin D Milk", "Nature's Own Honey Wheat Bread", "Kraft Singles American Cheese Slices", "Fresh Lemon", "Fresh Navel Orange", "Fresh Gala Apple", "Fresh Organic Roma Tomatoes", "Fresh Iceberg Lettuce Head")
)

# Applying lookup to target_raw
target_raw_clean <- target_raw |>
  left_join(lookup, by=c("Product_Name" = "target_raw_names")) |>
  mutate(Product_Name = coalesce(walmart_raw_names, Product_Name))

# Joining Walmart and Target Data
clean_data <- full_join(walmart_raw, target_raw_clean, by="Product_Name")

clean_data <- clean_data |>
  rename(
    Date = Date.x,
    Walmart_Price = Product_Price.x,
    Walmart_Size = Product_Size.x,
    Target_Price = Product_Price.y,
    Target_Size = Product_Size.y
  ) |>
  select(Date, Product_Name, Walmart_Price, Walmart_Size, Target_Price, Target_Size)

# Writing to CSV
output_file <- "clean_price_data/price_data.csv"
if(!dir.exists("clean_price_data")) {
  dir.create("clean_price_data")
}

write_csv(clean_data, output_file)
