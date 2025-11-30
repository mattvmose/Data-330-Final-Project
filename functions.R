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
  if (!is.numeric(df$Walmart_Price)) {
    df <- df |> mutate(Walmart_Price = as.numeric(Walmart_Price))
  }
  if (!is.numeric(df$Target_Price)) {
    df <- df |> mutate(Target_Price = as.numeric(Target_Price))
  }
  
  df |>
    mutate(
      price_diff = Walmart_Price - Target_Price,
      abs_diff = abs(price_diff),
      percent_diff = (Target_Price - Walmart_Price) / Walmart_Price*100,
      cheaper = if_else(Walmart_Price < Target_Price, "Walmart", "Target")
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
    pivot_longer(cols = c(Walmart_Price, Target_Price),
                 names_to = "Source", values_to = "Price")
  plot <- ggplot(plot_data, aes(x=Date, y=Price, color=Source, group=Source)) +
    geom_line() +
    geom_point() +
    facet_wrap(~ Product_Name, scales = "free_y") +
    labs(title = "Price Trends Over Time",
         x = "Date", y = "Price ($)", color = "Source")
  ggsave(output_file, plot=plot, width=10, height=6)
}
