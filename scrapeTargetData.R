# scrapeTargetData.R

library(jsonlite)
library(rvest)
library(readr)

egg_url <- "https://redsky.target.com/redsky_aggregations/v1/web/pdp_client_v1?key=9f36aeafbe60771e321a7cc95a78140772ab3e96&tcin=94684060&is_bot=false&store_id=1137&pricing_store_id=1137" #322
milk_url <- "https://redsky.target.com/redsky_aggregations/v1/web/pdp_client_v1?key=9f36aeafbe60771e321a7cc95a78140772ab3e96&tcin=94800147&is_bot=false&store_id=322&pricing_store_id=1137" #322
bread_url <- "https://redsky.target.com/redsky_aggregations/v1/web/pdp_client_v1?key=9f36aeafbe60771e321a7cc95a78140772ab3e96&tcin=13159011&is_bot=false&store_id=1137&pricing_store_id=1137" #322
cheese_url <- "https://redsky.target.com/redsky_aggregations/v1/web/pdp_client_v1?key=9f36aeafbe60771e321a7cc95a78140772ab3e96&tcin=12955138&is_bot=false&store_id=1137&pricing_store_id=1137"
lemon_url <- "https://redsky.target.com/redsky_aggregations/v1/web/pdp_client_v1?key=9f36aeafbe60771e321a7cc95a78140772ab3e96&tcin=15013629&is_bot=false&store_id=1137&pricing_store_id=1137"
orange_url <- "https://redsky.target.com/redsky_aggregations/v1/web/pdp_client_v1?key=9f36aeafbe60771e321a7cc95a78140772ab3e96&tcin=15026732&is_bot=false&store_id=1137&pricing_store_id=1137"
apple_url <- "https://redsky.target.com/redsky_aggregations/v1/web/pdp_client_v1?key=9f36aeafbe60771e321a7cc95a78140772ab3e96&tcin=15014055&is_bot=false&store_id=1137&pricing_store_id=1137"
tomato_url <- "https://redsky.target.com/redsky_aggregations/v1/web/pdp_client_v1?key=9f36aeafbe60771e321a7cc95a78140772ab3e96&tcin=94499414&is_bot=false&store_id=1137&pricing_store_id=1137"
lettuce_url <- "https://redsky.target.com/redsky_aggregations/v1/web/pdp_client_v1?key=9f36aeafbe60771e321a7cc95a78140772ab3e96&tcin=14919690&is_bot=false&store_id=1137&pricing_store_id=1137"

# Eggs
egg_page <- fromJSON(egg_url, flatten=TRUE)
egg_price <- egg_page$data$product$price$current_retail_min
egg_name <- egg_page$data$product$item$product_description$title


# Milk
milk_page <- fromJSON(milk_url, flatten=TRUE)
milk_price <- milk_page$data$product$price$current_retail_min
milk_name <- milk_page$data$product$item$product_description$title

# Breads
bread_page <- fromJSON(bread_url, flatten=TRUE)
bread_price <- bread_page$data$product$price$current_retail
bread_name <- bread_page$data$product$item$product_description$title

# Cheese
cheese_page <- fromJSON(cheese_url, flatten=TRUE)
cheese_price <- cheese_page$data$product$price$current_retail
cheese_name <- cheese_page$data$product$item$product_description$title

# Lemon
lemon_page <- fromJSON(lemon_url, flatten=TRUE)
lemon_price <- lemon_page$data$product$price$current_retail
lemon_name <- lemon_page$data$product$item$product_description$title

# Orange
orange_page <- fromJSON(orange_url, flatten=TRUE)
orange_price <- orange_page$data$product$price$current_retail
orange_name <- orange_page$data$product$item$product_description$title

# Apple
apple_page <- fromJSON(apple_url, flatten=TRUE)
apple_price <- apple_page$data$product$price$current_retail
apple_name <- apple_page$data$product$item$product_description$title

# Tomato
tomato_page <- fromJSON(tomato_url, flatten=TRUE)
tomato_price <- tomato_page$data$product$price$current_retail
tomato_name <- tomato_page$data$product$item$product_description$title

# Lettuce
lettuce_page <- fromJSON(lettuce_url, flatten=TRUE)
lettuce_price <- lettuce_page$data$product$price$current_retail
lettuce_name <- lettuce_page$data$product$item$product_description$title

# Milk, Bread, Eggs Dataframe
date <- Sys.Date()

price_df <- data.frame(
  Date = date,
  Product_Name = c(egg_name, milk_name, bread_name, cheese_name, lemon_name, orange_name, apple_name, tomato_name, lettuce_name),
  Product_Price = c(egg_price, milk_price, bread_price, cheese_price, lemon_price, orange_price, apple_price, tomato_price, lettuce_price)
)

# CSV
output_file <- "raw_price_data/raw_target_data.csv"
if(!dir.exists("raw_price_data")) {
  dir.create("raw_price_data")
}

write_csv(price_df, output_file)