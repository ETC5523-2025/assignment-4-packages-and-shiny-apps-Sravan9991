## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5
)

## ----eval=FALSE---------------------------------------------------------------
# # Install from GitHub
# remotes::install_github("ETC5523-2025/assignment-4-packages-Sravan9991")

## ----eval=FALSE---------------------------------------------------------------
# library(bushfireRisk)
# library(dplyr)
# library(ggplot2)

## ----eval=FALSE---------------------------------------------------------------
# # Load the data
# data("bushfire_data")
# 
# # View structure
# str(bushfire_data)
# 
# # Summary statistics
# summary(bushfire_data)
# 
# # View first few rows
# head(bushfire_data)

## ----eval=FALSE---------------------------------------------------------------
# data("climate_attribution")
# head(climate_attribution)

## ----eval=FALSE---------------------------------------------------------------
# data("regional_summary")
# regional_summary

## ----eval=FALSE---------------------------------------------------------------
# # FFDI change in Southeast Australia from 1950 to 2020
# calculate_risk_change(
#   data = bushfire_data,
#   region = "Southeast Australia",
#   start_year = 1950,
#   end_year = 2020,
#   metric = "ffdi_mean"
# )
# 
# # Change in extreme fire days
# calculate_risk_change(
#   data = bushfire_data,
#   region = "Southeast Australia",
#   start_year = 1980,
#   end_year = 2020,
#   metric = "extreme_days"
# )

## ----eval=FALSE---------------------------------------------------------------
# # Single region
# plot_ffdi_trend(
#   data = bushfire_data,
#   regions = "Southeast Australia",
#   add_trend = TRUE
# )
# 
# # Compare multiple regions
# plot_ffdi_trend(
#   data = bushfire_data,
#   regions = c("Southeast Australia", "Eastern Australia", "Southern Australia"),
#   add_trend = TRUE
# )
# 
# # Interactive plot
# plot_ffdi_trend(
#   data = bushfire_data,
#   regions = "Southeast Australia",
#   interactive = TRUE
# )

## ----eval=FALSE---------------------------------------------------------------
# # Recent comparison (2000-2020)
# compare_regions(bushfire_data, year_range = c(2000, 2020))
# 
# # Historical comparison
# compare_regions(bushfire_data, year_range = c(1950, 2020))

## ----eval=FALSE---------------------------------------------------------------
# library(ggplot2)
# library(dplyr)
# 
# # Filter for Southeast Australia
# southeast_data <- bushfire_data %>%
#   filter(region == "Southeast Australia")
# 
# # Create plot
# ggplot(southeast_data, aes(x = year, y = ffdi_mean)) +
#   geom_line(color = "#d7191c", linewidth = 1) +
#   geom_smooth(method = "lm", se = TRUE, color = "#2c7bb6") +
#   labs(
#     title = "Fire Danger Trends in Southeast Australia",
#     subtitle = "1950-2020",
#     x = "Year",
#     y = "Mean Forest Fire Danger Index",
#     caption = "Data source: Oldenborgh et al. (2021)"
#   ) +
#   theme_minimal() +
#   theme(
#     plot.title = element_text(size = 14, face = "bold"),
#     plot.subtitle = element_text(color = "gray40")
#   )

## ----eval=FALSE---------------------------------------------------------------
# # Calculate average extreme days by region (2000-2020)
# extreme_summary <- bushfire_data %>%
#   filter(year >= 2000) %>%
#   group_by(region) %>%
#   summarise(
#     avg_extreme_days = mean(extreme_days, na.rm = TRUE),
#     max_extreme_days = max(extreme_days, na.rm = TRUE)
#   ) %>%
#   arrange(desc(avg_extreme_days))
# 
# # Bar plot
# ggplot(extreme_summary, aes(x = reorder(region, avg_extreme_days),
#                             y = avg_extreme_days)) +
#   geom_col(fill = "#e74c3c") +
#   coord_flip() +
#   labs(
#     title = "Average Extreme Fire Days by Region",
#     subtitle = "2000-2020 Average",
#     x = NULL,
#     y = "Average Number of Extreme Fire Days per Year"
#   ) +
#   theme_minimal()

## ----eval=FALSE---------------------------------------------------------------
# # Plot natural vs anthropogenic scenarios
# ggplot(climate_attribution, aes(x = year, y = ffdi_mean,
#                                 color = scenario, linetype = scenario)) +
#   geom_line(linewidth = 1.2) +
#   scale_color_manual(
#     values = c("Natural Climate" = "#2c7bb6",
#                "Anthropogenic Climate" = "#d7191c")
#   ) +
#   labs(
#     title = "Climate Change Attribution Analysis",
#     subtitle = "Natural vs Anthropogenic Climate Influence",
#     x = "Year",
#     y = "Forest Fire Danger Index",
#     color = "Scenario",
#     linetype = "Scenario"
#   ) +
#   theme_minimal() +
#   theme(legend.position = "bottom")

## ----eval=FALSE---------------------------------------------------------------
# launch_bushfire_app()

