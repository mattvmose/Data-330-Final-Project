#update_master_data.R
source("functions.R")

library(dplyr)
library(readr)
library(ggplot2)
source("functions.R")

today_data <- read.csv("clean_price_data/price_data.csv")

today_data <- add_metrics(today_data)

if(!dir.exists("final_data")) {
  dir.create("final_data")
}
if(!dir.exists("plots")) {
  dir.create("plots")
}

master_data <- append_master(today_data, "final_data/master_data.csv")

# Plotting graph
# Checks to see if there is data in the master_data dataframe
# If no data, it sends a warning that there is no data to plot
if (nrow(master_data)==0) {
  warning("No data available to plot.")
} else{
  # If there is data, then it plots it on the graph
  plot_trends(master_data)
}