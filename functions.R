# functions.R

library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)

# Normalizing the date column
normalize_date <- function(df) {
  if (!inherits(df$Date, "Date")) {
    df <- df |> mutate(Date = as.Date(Date))
  }
  return(df)
}

# Calculating Metrics
add_metrics <- function(df) {
  if (!is.numeric(df$East_Price)) {
    df <- df |> mutate(East_Price = as.numeric(East_Price))
  }
  if (!is.numeric(df$West_Price)) {
    df <- df |> mutate(West_Price = as.numeric(West_Price))
  }
  
  df |>
    mutate(
      price_diff = abs(East_Price - West_Price),
      percent_diff = (West_Price - East_Price) / East_Price*100,
      cheaper = if_else(East_Price < West_Price, "East Coast", "West Coast")
    )
}

# Append to Master File
append_master <- function(today_data, master_file) {
  today_data <- normalize_date(today_data)
  
  if (file.exists(master_file)) {
    master_data <- read_csv(master_file) |>
      normalize_date() |>
      bind_rows(today_data)
  } else {
    master_data <- today_data
  }
  
  write_csv(master_data, master_file)
}

# Plotting price trends
plot_trends <- function(df, output_file = "plots/price_trends.png") {
  plot_data <- df |>
    pivot_longer(cols = c(East_Price, West_Price, Cost_Of_Living),
                 names_to = "Source", values_to = "Price")
  plot <- ggplot(plot_data, aes(x=Date, y=Price, color=Source, group=Source)) +
    geom_line() +
    geom_point() +
    facet_wrap(~ Product_Name, scales = "free_y") +
    labs(title = "Price Trends Over Time",
         x = "Date", y = "Price ($)", color = "Source")
  ggsave(output_file, plot=plot, width=10, height=6)
}
