# scrapeAmazonData.R

library(rvest)
library(dplyr)
library(readr)
library(httr)
library(jsonlite)

# Helper function to return x if it exists, or if not return y
use_if_not_null <- function(x, y) {
  if (is.null(x) || length(x)==0) y else x
}

# Function to scrape Amazon Fresh product data
scrape_amazon_fresh <- function(url) {
  response <- GET(
    url,
    add_headers(
      "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
      "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "Accept-Language" = "en-US,en;q=0.5",
      "Referer" = "https://www.amazon.com/"
    )
  )
  
  html <- read_html(response)
  
  # Try JSON-LD first
  json_text <- html |>
    html_nodes("script[type='application/ld+json']") |>
    html_text()
  
  parsed <- tryCatch(
    {
      fromJSON(json_text)
    },
    error = function(e) {
      NULL
    }
  )
  
  if (!is.null(parsed)) {
    name <- use_if_not_null(parsed$name, na)
    price <- use_if_not_null(parsed$offers$price, NA)
  } else {
    name <- html |> html_node("#productTitle") |> html_text(trim=TRUE)
    price <- html |> html_node(".a-price .a-offscreen") |> html_text(trim=TRUE)
  }
  
  tibble(Product_Name = name, Product_Price = price)
}

#URLs for Amazon Products
urls <- c(
  "https://a.co/d/8KVpJZE", #Eggs
  "https://a.co/d/h4lDAdO", #Milk
  "https://a.co/d/cCRLwKm", #Bread
  "https://a.co/d/9UTMqiW", #Cheese
  "https://a.co/d/gAjhrlj", #Lemon
  "https://a.co/d/e2q1kWR", #Orange
  "https://a.co/d/eJ53tEN", #Apple
  "https://a.co/d/e5t14Oa", #Tomato
  "https://a.co/d/9OyGmY0" #Lettuce
)

results <- bind_rows(lapply(urls, scrape_amazon_fresh)) |>
  mutate(Date = Sys.Date())

# Append to CSV
output_file <- "raw_price_data/raw_amazon_data.csv"
if (!dir.exists("raw_price_data")) {
  dir.create("raw_price_data")
}

write_csv(results, output_file)

