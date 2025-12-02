# clean_price_data.R

library(readr)
library(dplyr)
library(stringr)

# Loading raw CSVs into R
east_target_raw <- read.csv("raw_price_data/raw_east_target_data.csv")
west_target_raw <- read.csv("raw_price_data/raw_west_target_data.csv")
COL_raw <- read.csv("raw_price_data/raw_COL_data.csv")

# Normalizing Data Types
east_target_raw <- east_target_raw |> mutate(Product_Price = as.numeric(Product_Price),
                                   Date = as.Date(Date, format="%Y-%m-%d"),
                                   Product_Name = str_trim(str_remove(Product_Name, " - .*|,.*")),
                                   Product_Name = str_replace_all(Product_Name, "&#39;", "'"))

west_target_raw <- west_target_raw |> mutate(Product_Price = as.numeric(Product_Price),
                                   Date = as.Date(Date, format="%Y-%m-%d"),
                                   Product_Name = str_trim(str_remove(Product_Name, " - .*|,.*")),
                                   Product_Name = str_replace_all(Product_Name, "&#39;", "'"))

COL_raw <- COL_raw |> mutate(Product_Name = str_trim(str_remove(Product_Name, " - .*|,.*")),
                             Product_Name = str_replace_all(Product_Name, "&#39;", "'"),
                             Product_Price = str_replace_all(Product_Price, "[^0-9.]", ""),
                             Product_Price = as.numeric(Product_Price),
                             Date = as.Date(Date, format="%Y-%m-%d"))

# Joining Walmart and Target Data
clean_data <- east_target_raw |> full_join(west_target_raw, by=c("Date", "Product_Name")) |> full_join(COL_raw, by=c("Date", "Product_Name"))

clean_data <- clean_data |>
  rename(
    Date = Date,
    East_Price = Product_Price.x,
    West_Price = Product_Price.y,
    Cost_Of_Living = Product_Price
  ) |>
  select(Date, Product_Name, East_Price, West_Price, Cost_Of_Living)

# Writing to CSV
output_file <- "clean_price_data/price_data.csv"
if(!dir.exists("clean_price_data")) {
  dir.create("clean_price_data")
}

write_csv(clean_data, output_file)
