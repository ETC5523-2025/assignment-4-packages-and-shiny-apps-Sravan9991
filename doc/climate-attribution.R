## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5
)

## ----eval=FALSE---------------------------------------------------------------
# library(bushfireRisk)
# library(ggplot2)
# library(dplyr)
# 
# # Load attribution data
# data("climate_attribution")
# 
# # Visualize the scenarios
# ggplot(climate_attribution,
#        aes(x = year, y = ffdi_mean, color = scenario)) +
#   geom_line(linewidth = 1.2) +
#   geom_ribbon(aes(ymin = ffdi_mean - 1, ymax = ffdi_mean + 1,
#                   fill = scenario),
#               alpha = 0.2, color = NA) +
#   scale_color_manual(
#     values = c("Natural Climate" = "#2c7bb6",
#                "Anthropogenic Climate" = "#d7191c")
#   ) +
#   scale_fill_manual(
#     values = c("Natural Climate" = "#2c7bb6",
#                "Anthropogenic Climate" = "#d7191c")
#   ) +
#   labs(
#     title = "Natural vs Anthropogenic Climate Influence on Fire Risk",
#     subtitle = "The gap shows human-caused increase in fire danger",
#     x = "Year",
#     y = "Forest Fire Danger Index",
#     color = "Climate Scenario",
#     fill = "Climate Scenario"
#   ) +
#   theme_minimal() +
#   theme(legend.position = "bottom")

## ----eval=FALSE---------------------------------------------------------------
# # Calculate the increase in fire danger from 1950 to 2020
# calculate_risk_change(
#   bushfire_data,
#   region = "Southeast Australia",
#   start_year = 1950,
#   end_year = 2020,
#   metric = "ffdi_mean"
# )

## ----eval=FALSE---------------------------------------------------------------
# # View attribution confidence by region
# data("regional_summary")
# 
# regional_summary %>%
#   select(region, attribution_confidence) %>%
#   arrange(desc(attribution_confidence))

## ----eval=FALSE---------------------------------------------------------------
# # Compare fire danger trends across regions
# bushfire_data %>%
#   group_by(region, decade = floor(year/10)*10) %>%
#   summarise(mean_ffdi = mean(ffdi_mean), .groups = "drop") %>%
#   ggplot(aes(x = decade, y = mean_ffdi, color = region)) +
#   geom_line(linewidth = 1) +
#   geom_point() +
#   labs(
#     title = "Fire Danger by Region and Decade",
#     x = "Decade",
#     y = "Mean FFDI",
#     color = "Region"
#   ) +
#   theme_minimal() +
#   theme(legend.position = "bottom")

## ----eval=FALSE---------------------------------------------------------------
# # Examine extreme fire days over time
# bushfire_data %>%
#   filter(region == "Southeast Australia") %>%
#   ggplot(aes(x = year, y = extreme_days)) +
#   geom_point(alpha = 0.6, color = "#e74c3c") +
#   geom_smooth(method = "lm", se = TRUE, color = "#2c3e50") +
#   labs(
#     title = "Extreme Fire Days in Southeast Australia",
#     subtitle = "Days with FFDI > 50 per year",
#     x = "Year",
#     y = "Number of Extreme Fire Days"
#   ) +
#   theme_minimal()

## ----eval=FALSE---------------------------------------------------------------
# # Example: Calculate trend for Southeast Australia
# southeast_data <- bushfire_data %>%
#   filter(region == "Southeast Australia")
# 
# model <- lm(ffdi_mean ~ year, data = southeast_data)
# summary(model)
# 
# # Extract trend
# trend_per_year <- coef(model)[2]
# trend_per_decade <- trend_per_year * 10
# 
# cat("Fire danger is increasing by", round(trend_per_decade, 2),
#     "FFDI points per decade")

## ----eval=FALSE---------------------------------------------------------------
# # Project future trends (illustrative)
# southeast_data <- bushfire_data %>%
#   filter(region == "Southeast Australia")
# 
# model <- lm(ffdi_mean ~ year, data = southeast_data)
# 
# future_years <- data.frame(year = 2021:2050)
# future_years$predicted_ffdi <- predict(model, newdata = future_years)
# 
# # Combine historical and projected
# combined <- bind_rows(
#   southeast_data %>% select(year, ffdi_mean) %>% mutate(type = "Historical"),
#   future_years %>% rename(ffdi_mean = predicted_ffdi) %>% mutate(type = "Projected")
# )
# 
# ggplot(combined, aes(x = year, y = ffdi_mean, color = type)) +
#   geom_line(linewidth = 1) +
#   geom_vline(xintercept = 2020, linetype = "dashed", color = "gray50") +
#   scale_color_manual(values = c("Historical" = "#2c3e50",
#                                 "Projected" = "#e74c3c")) +
#   labs(
#     title = "Projected Fire Danger in Southeast Australia",
#     subtitle = "If current warming trends continue",
#     x = "Year",
#     y = "Mean FFDI",
#     color = NULL
#   ) +
#   theme_minimal() +
#   theme(legend.position = "bottom")

## ----eval=FALSE---------------------------------------------------------------
# # Calculate the difference in 2020
# attribution_2020 <- climate_attribution %>%
#   filter(year == 2020) %>%
#   select(scenario, ffdi_mean) %>%
#   pivot_wider(names_from = scenario, values_from = ffdi_mean) %>%
#   mutate(
#     human_contribution = `Anthropogenic Climate` - `Natural Climate`,
#     percent_increase = (human_contribution / `Natural Climate`) * 100
#   )
# 
# attribution_2020

## ----eval=FALSE---------------------------------------------------------------
# # Calculate the attribution gap for each year
# attribution_gap <- climate_attribution %>%
#   select(year, scenario, ffdi_mean) %>%
#   pivot_wider(names_from = scenario, values_from = ffdi_mean) %>%
#   mutate(human_contribution = `Anthropogenic Climate` - `Natural Climate`)
# 
# ggplot(attribution_gap, aes(x = year, y = human_contribution)) +
#   geom_area(fill = "#e74c3c", alpha = 0.7) +
#   geom_line(color = "#c0392b", linewidth = 1) +
#   labs(
#     title = "Human Contribution to Fire Danger Over Time",
#     subtitle = "The growing gap between natural and observed climate",
#     x = "Year",
#     y = "Additional FFDI from Human Activity"
#   ) +
#   theme_minimal()

