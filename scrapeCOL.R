# scrapeCOL.R

library(rvest)
library(dplyr)
library(readr)

url <- "https://www.numbeo.com/cost-of-living/country_result.jsp?country=United+States"

page <- read_html(url)

prices <- page |> html_nodes("span.first_currency") |> html_text()
pattern <- c(12, 9, 10, 13, 17, 18, 16, 19, 22)
prices <- prices[pattern]

COL_data <- tibble(
  Date = Sys.Date(),
  Product_Name = names,
  Product_Price = prices
)

# CSV
output_file <- "raw_price_data/raw_COL_data.csv"
if(!dir.exists("raw_price_data")) {
  dir.create("raw_price_data")
}

write_csv(COL_data, output_file)