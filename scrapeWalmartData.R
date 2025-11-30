# scrapeWalmartData.R

library(rvest)
library(dplyr)
library(readr)

egg_url <- "https://www.walmart.com/ip/Vital-Farms-Pasture-Raised-Grade-A-Large-Brown-Eggs-12-Count/115864065?classType=REGULAR&from=%2Fsearch&sid=0d4a8161-301e-4cfc-9e70-42fef657e5ea"
milk_url <- "https://www.walmart.com/ip/Horizon-Organic-High-Vitamin-D-Whole-Milk-High-Vitamin-D-Whole-128-fl-oz-Jug/350048336?classType=REGULAR&from=%2Fsearch&sid=9c833a1a-f084-48ba-93bf-359bcd86f3ce"
bread_url <- "https://www.walmart.com/ip/Nature-s-Own-Honey-Wheat-Sandwich-Bread-Loaf-20-oz-Shelf-Stable/10450000?classType=REGULAR&athbdg=L1600&from=%2Fsearch&sid=8699a96d-61bb-4664-8053-743d6e1ea378"
cheese_url <- "https://www.walmart.com/ip/Kraft-Singles-American-Cheese-Slices-24-Ct-Pk/10452905?classType=REGULAR&athbdg=L1600&from=%2Fsearch&sid=7a1ec3ae-8a9c-4dd9-95f9-5991e30d84bd"
lemon_url <- "https://www.walmart.com/ip/Fresh-Lemon-Each/41752773?classType=REGULAR&athbdg=L1300&from=%2Fsearch&sid=ac8a4e78-878a-4deb-9d85-ddededc2e0ca"
orange_url <- "https://www.walmart.com/ip/Fresh-Navel-Orange-Each/162577028?classType=REGULAR&athbdg=L1300&from=%2Fsearch&sid=d82cd121-e589-492b-8277-2ef76bb5a3c7"
apple_url <- "https://www.walmart.com/ip/Fresh-Gala-Apple-Each/44390953?classType=REGULAR&athbdg=L1300&from=%2Fsearch&sid=3640bf0d-48e3-48c1-a1d3-b783e96e3bb2"
tomato_url <- "https://www.walmart.com/ip/Fresh-Roma-Tomato-Each/44390944?classType=REGULAR&athbdg=L1200&from=%2Fsearch&sid=59b5f1fd-419a-4c02-abc3-e76cc71c11e1"
lettuce_url <- "https://www.walmart.com/ip/Fresh-Iceberg-Lettuce-Each/10402650?classType=REGULAR&from=%2Fsearch&sid=4a8bb86a-c6ce-46ef-b215-ddd22f9a3c9d"


# Eggs
egg_page <- read_html(egg_url)
egg_price <- html_element(egg_page, "span.inline-flex.flex-column") |> html_text()
egg_name <- html_element(egg_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()

# Milk
milk_page <- read_html(milk_url)
milk_price <- html_element(milk_page, "span.inline-flex.flex-column") |> html_text()
milk_name <- html_element(milk_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()

# Breads
bread_page <- read_html(bread_url)
bread_price <- html_element(bread_page, "span.inline-flex.flex-column") |> html_text()
bread_name <- html_element(bread_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()

# Cheese
cheese_page <- read_html(cheese_url)
cheese_price <- html_element(cheese_page, "span.inline-flex.flex-column") |> html_text()
cheese_name <- html_element(cheese_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()

# Lemons
lemon_page <- read_html(lemon_url)
lemon_price <- html_element(lemon_page, "span.inline-flex.flex-column") |> html_text()
lemon_name <- html_element(lemon_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()

# Oranges
orange_page <- read_html(orange_url)
orange_price <- html_element(orange_page, "span.inline-flex.flex-column") |> html_text()
orange_name <- html_element(orange_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()

# Apples
apple_page <- read_html(apple_url)
apple_price <- html_element(apple_page, "span.inline-flex.flex-column") |> html_text()
apple_name <- html_element(apple_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()

# Tomatoes
tomato_page <- read_html(tomato_url)
tomato_price <- html_element(tomato_page, "span.inline-flex.flex-column") |> html_text()
tomato_name <- html_element(tomato_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()

# Lettuce
lettuce_page <- read_html(lettuce_url)
lettuce_price <- html_element(lettuce_page, "span.inline-flex.flex-column") |> html_text()
lettuce_name <- html_element(lettuce_page, "h1#main-title.dark-gray.mv1.lh-copy.f4.mh0.b") |> html_text()

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