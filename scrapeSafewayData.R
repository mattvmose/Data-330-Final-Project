#scrapeSafewayData.R

# Load Libraries
library(rvest)
library(httr)
library(dplyr)
library(jsonlite)
library(readr)

# Function to scrape product page
scrape_safeway <- function(url) {
  # Request page with headers to mimic browser
  response <- GET(url, add_headers("User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36"))
  page <- read_html(response)
  
  # Extract JSON Blocks
  json_blocks <- page |>
    html_nodes("script[type='application/ld+json']") |>
    html_text()

  # JSON protection
  if (length(json_blocks) < 2 || any(is.na(json_blocks))) {
    warning(paste("No valid JSON found at:", url))
    return(tibble(Date = Sys.Date(), Product_Name = NA, Product_Price = NA))
  }
  
  #Parsing first JSON block
  product_name <- fromJSON(json_blocks[1])
  product_price <- fromJSON(json_blocks[2])
  
  #Forming tibble
  tibble(
    Date = Sys.Date(),
    Product_Name = product_name$name,
    Product_Price = product_price$offers$price
  )
}

# List of safeway URLs
urls <- c(
  "https://www.safeway.com/shop/product-details.960100459.html", #Egg
  "https://www.safeway.com/shop/product-details.136050013.html", #Milk
  "https://www.safeway.com/shop/product-details.960002359.html", #Bread
  "https://www.safeway.com/shop/product-details.137010160.html", #Cheese
  "https://www.safeway.com/shop/product-details.184080250.html", #Lemon
  "https://www.safeway.com/shop/product-details.184080188.html", #Orange
  "https://www.safeway.com/shop/product-details.184020149.html", #Apple
  "https://www.safeway.com/shop/product-details.184570068.html", #Tomato
  "https://www.safeway.com/shop/product-details.184420001.html"
)

#Initialize empty tibble
safeway_data <- tibble(Date = as.Date(character()), Product_Name = character(), Product_Price=character())

#Scrapig product data
for (u in urls) {
  results <- scrape_safeway(u)
  safeway_data <- bind_rows(safeway_data, results)
}

#Write CSV
output_file <- "raw_price_data/raw_safeway_data.csv"
if(!dir.exists("raw_price_data")) {
  dir.create("raw_price_data")
}

write_csv(safeway_data, output_file)


