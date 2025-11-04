## code to prepare `bushfire_data` dataset goes here

# Create synthetic bushfire risk data based on Oldenborgh et al. (2021) findings
# This represents Fire Danger Index trends across Australian regions

set.seed(123)

years <- 1950:2020
regions <- c("Southeast Australia", "Eastern Australia", "Southern Australia", 
             "Northern Australia", "Western Australia")

# Generate realistic fire danger trends
bushfire_data <- expand.grid(
  year = years,
  region = regions,
  stringsAsFactors = FALSE
)

# Add Forest Fire Danger Index (FFDI) with regional and temporal patterns
bushfire_data$ffdi_mean <- sapply(1:nrow(bushfire_data), function(i) {
  year <- bushfire_data$year[i]
  region <- bushfire_data$region[i]
  
  # Base level varies by region
  base <- switch(region,
                 "Southeast Australia" = 15,
                 "Eastern Australia" = 12,
                 "Southern Australia" = 13,
                 "Northern Australia" = 8,
                 "Western Australia" = 14)
  
  # Trend: Southeast shows strongest increase (research finding)
  trend_strength <- switch(region,
                           "Southeast Australia" = 0.08,
                           "Eastern Australia" = 0.05,
                           "Southern Australia" = 0.06,
                           "Northern Australia" = 0.02,
                           "Western Australia" = 0.04)
  
  # Calculate value with trend and random variation
  value <- base + (year - 1950) * trend_strength + rnorm(1, 0, 1.5)
  
  # Add climate change acceleration post-1980
  if (year > 1980) {
    value <- value + (year - 1980) * 0.02 * trend_strength
  }
  
  return(max(0, value))  # FFDI can't be negative
})

# Add extreme fire days (days with FFDI > 50, "extreme" threshold)
bushfire_data$extreme_days <- sapply(1:nrow(bushfire_data), function(i) {
  year <- bushfire_data$year[i]
  region <- bushfire_data$region[i]
  
  base_days <- switch(region,
                      "Southeast Australia" = 3,
                      "Eastern Australia" = 2,
                      "Southern Australia" = 2.5,
                      "Northern Australia" = 1,
                      "Western Australia" = 2)
  
  # Increasing trend in extreme days
  trend <- switch(region,
                  "Southeast Australia" = 0.12,
                  "Eastern Australia" = 0.08,
                  "Southern Australia" = 0.09,
                  "Northern Australia" = 0.03,
                  "Western Australia" = 0.07)
  
  days <- base_days + (year - 1950) * trend + rnorm(1, 0, 0.5)
  
  return(max(0, round(days)))
})

# Add area burned (thousands of hectares)
bushfire_data$area_burned_1000ha <- sapply(1:nrow(bushfire_data), function(i) {
  year <- bushfire_data$year[i]
  region <- bushfire_data$region[i]
  ffdi <- bushfire_data$ffdi_mean[i]
  
  # Area burned correlates with FFDI but with high variance
  base_area <- switch(region,
                      "Southeast Australia" = 50,
                      "Eastern Australia" = 40,
                      "Southern Australia" = 45,
                      "Northern Australia" = 200,  # Northern Australia has larger fires
                      "Western Australia" = 60)
  
  # Exponential relationship with FFDI
  area <- base_area * (1 + (ffdi - 10) / 10)^1.5 + rnorm(1, 0, 20)
  
  # Occasional extreme years (like Black Summer 2019-2020)
  if (year >= 2019 && region == "Southeast Australia") {
    area <- area * 3
  }
  
  return(max(0, round(area, 1)))
})

# Add attribution confidence (% confidence that climate change increased risk)
bushfire_data$attribution_confidence <- sapply(1:nrow(bushfire_data), function(i) {
  region <- bushfire_data$region[i]
  
  # Based on research findings
  conf <- switch(region,
                 "Southeast Australia" = 95,
                 "Eastern Australia" = 90,
                 "Southern Australia" = 88,
                 "Northern Australia" = 75,
                 "Western Australia" = 85)
  
  return(conf)
})

# Save the dataset
usethis::use_data(bushfire_data, overwrite = TRUE)

# Create climate attribution comparison data
climate_attribution <- data.frame(
  scenario = rep(c("Natural Climate", "Anthropogenic Climate"), each = 71),
  year = rep(1950:2020, 2),
  ffdi_mean = c(
    # Natural scenario: slight increase due to natural variability
    12 + (1950:2020 - 1950) * 0.01 + rnorm(71, 0, 0.8),
    # Anthropogenic scenario: stronger increase
    12 + (1950:2020 - 1950) * 0.06 + rnorm(71, 0, 0.8)
  )
)

climate_attribution$extreme_probability <- ifelse(
  climate_attribution$scenario == "Natural Climate",
  0.05 + (climate_attribution$year - 1950) * 0.0001,  # Slow increase
  0.05 + (climate_attribution$year - 1950) * 0.0008   # Faster increase
)

usethis::use_data(climate_attribution, overwrite = TRUE)

# Create regional summary statistics
regional_summary <- bushfire_data %>%
  dplyr::group_by(region) %>%
  dplyr::summarise(
    mean_ffdi = mean(ffdi_mean, na.rm = TRUE),
    max_ffdi = max(ffdi_mean, na.rm = TRUE),
    total_area_burned = sum(area_burned_1000ha, na.rm = TRUE),
    avg_extreme_days = mean(extreme_days, na.rm = TRUE),
    trend_coefficient = lm(ffdi_mean ~ year)$coefficients[2],
    attribution_confidence = mean(attribution_confidence)
  ) %>%
  dplyr::arrange(desc(mean_ffdi))

usethis::use_data(regional_summary, overwrite = TRUE)

message("Datasets created successfully!")
message("- bushfire_data: Main dataset with yearly regional fire risk metrics")
message("- climate_attribution: Comparison of natural vs anthropogenic scenarios")
message("- regional_summary: Summary statistics by region")
