# scrapeWalmartData.R

library(rvest)
library(dplyr)
library(readr)
library(httr)

# Sets config to use across all HTTP requests
set_config(
  config(
    useragent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    httpheader = c(
      "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "Accept-Language" = "en-US,en;q=0.5",
      "Referer" = "https://walmart.com/"
    )
  )
)

egg_url <- "https://www.walmart.com/ip/Vital-Farms-Pasture-Raised-Grade-A-Large-Brown-Eggs-12-Count/115864065"
milk_url <- "https://www.walmart.com/ip/Horizon-Organic-High-Vitamin-D-Whole-Milk-High-Vitamin-D-Whole-128-fl-oz-Jug/350048336"
bread_url <- "https://www.walmart.com/ip/Nature-s-Own-Honey-Wheat-Sandwich-Bread-Loaf-20-oz-Shelf-Stable/10450000"
cheese_url <- "https://www.walmart.com/ip/Kraft-Singles-American-Cheese-Slices-24-Ct-Pk/10452905"
lemon_url <- "https://www.walmart.com/ip/Fresh-Lemon-Each/41752773"
orange_url <- "https://www.walmart.com/ip/Fresh-Navel-Orange-Each/162577028"
apple_url <- "https://www.walmart.com/ip/Fresh-Gala-Apple-Each/44390953"
tomato_url <- "https://www.walmart.com/ip/Fresh-Roma-Tomato-Each/44390944"
lettuce_url <- "https://www.walmart.com/ip/Fresh-Iceberg-Lettuce-Each/10402650"


# Eggs
egg_page <- GET(egg_url) |> read_html()
egg_price <- html_element(egg_page, "span.inline-flex.flex-column") |> html_text()
egg_name <- html_element(egg_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()
Sys.sleep(5)

# Milk
milk_page <- GET(milk_url) |> read_html()
milk_price <- html_element(milk_page, "span.inline-flex.flex-column") |> html_text()
milk_name <- html_element(milk_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()
Sys.sleep(5)

# Breads
bread_page <- GET(bread_url) |> read_html()
bread_price <- html_element(bread_page, "span.inline-flex.flex-column") |> html_text()
bread_name <- html_element(bread_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()
Sys.sleep(5)

# Cheese
cheese_page <- GET(cheese_url) |> read_html()
cheese_price <- html_element(cheese_page, "span.inline-flex.flex-column") |> html_text()
cheese_name <- html_element(cheese_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()
Sys.sleep(5)

# Lemons
lemon_page <- GET(lemon_url) |> read_html()
lemon_price <- html_element(lemon_page, "span.inline-flex.flex-column") |> html_text()
lemon_name <- html_element(lemon_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()
Sys.sleep(5)

# Oranges
orange_page <- GET(orange_url) |> read_html()
orange_price <- html_element(orange_page, "span.inline-flex.flex-column") |> html_text()
orange_name <- html_element(orange_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()
Sys.sleep(5)

# Apples
apple_page <- GET(apple_url) |> read_html()
apple_price <- html_element(apple_page, "span.inline-flex.flex-column") |> html_text()
apple_name <- html_element(apple_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()
Sys.sleep(5)

# Tomatoes
tomato_page <- GET(tomato_url) |> read_html()
tomato_price <- html_element(tomato_page, "span.inline-flex.flex-column") |> html_text()
tomato_name <- html_element(tomato_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()
Sys.sleep(5)

# Lettuce
lettuce_page <- GET(lettuce_url) |> read_html()
lettuce_price <- html_element(lettuce_page, "span.inline-flex.flex-column") |> html_text()
lettuce_name <- html_element(lettuce_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()
Sys.sleep(5)

# Milk, Bread, Eggs Dataframe
date <- Sys.Date()

price_df <- data.frame(
  Date = date,
  Product_Name = c(egg_name, milk_name, bread_name, cheese_name, lemon_name, orange_name, apple_name, tomato_name, lettuce_name),
  Product_Price = c(egg_price, milk_price, bread_price, cheese_price, lemon_price, orange_price, apple_price, tomato_price, lettuce_price)
)

# CSV
output_file <- "raw_price_data/raw_walmart_data.csv"
if(!dir.exists("raw_price_data")) {
  dir.create("raw_price_data")
}


write_csv(price_df, output_file)

