# scrapeCOL.R

library(rvest)
library(dplyr)
library(readr)

url <- "https://www.numbeo.com/cost-of-living/country_result.jsp?country=United+States"

page <- read_html(url)

prices <- page |> html_nodes("span.first_currency") |> html_text()
pattern <- c(12, 9, 10, 13, 17, 18, 16, 19, 22)
prices <- prices[pattern]
product_names <- c("Vital Farms Pasture Raised Eggs", "Horizon Organic High Vitamin D Milk", "Nature&#39;s Own Honey Wheat Bread - 20oz,3.32", "Kraft Singles American Cheese Slices - 16oz/24ct", "Fresh Banana - each - Good &#38; Gather&#8482;", "Fresh Navel Orange - each", "Fresh Gala Apple - each", "Fresh Organic Roma Tomatoes - 1lb", "Fresh Iceberg Lettuce Head - each")

COL_data <- tibble(
  Date = Sys.Date(),
  Product_Name = product_names,
  Product_Price = prices
)

# CSV
output_file <- "raw_price_data/raw_COL_data.csv"
if(!dir.exists("raw_price_data")) {
  dir.create("raw_price_data")
}

write_csv(COL_data, output_file)
