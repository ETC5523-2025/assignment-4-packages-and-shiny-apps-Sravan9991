#' Calculate Risk Change Over Time
#'
#' Calculates the percentage change in bushfire risk for a specific region
#' between two years.
#'
#' @param data Data frame containing bushfire data (usually \code{bushfire_data})
#' @param region Character. Name of the Australian region to analyze
#' @param start_year Numeric. Starting year for comparison
#' @param end_year Numeric. Ending year for comparison
#' @param metric Character. The metric to calculate change for. Options are
#'   "ffdi_mean" (default), "extreme_days", or "area_burned_1000ha"
#'
#' @return A numeric value representing the percentage change. Positive values
#'   indicate an increase in risk.
#'
#' @examples
#' \dontrun{
#' # Calculate FFDI change in Southeast Australia from 1950 to 2020
#' calculate_risk_change(bushfire_data, "Southeast Australia", 1950, 2020)
#'
#' # Calculate change in extreme fire days
#' calculate_risk_change(bushfire_data, "Eastern Australia", 1980, 2020,
#'                      metric = "extreme_days")
#' }
#'
#' @export
#' @importFrom dplyr filter
calculate_risk_change <- function(data, region, start_year, end_year,
                                  metric = "ffdi_mean") {
  
  # Validate inputs
  if (!metric %in% c("ffdi_mean", "extreme_days", "area_burned_1000ha")) {
    stop("metric must be one of: 'ffdi_mean', 'extreme_days', 'area_burned_1000ha'")
  }
  
  if (start_year >= end_year) {
    stop("start_year must be less than end_year")
  }
  
  # Filter data for the specific region
  region_data <- data %>%
    dplyr::filter(region == !!region, year %in% c(start_year, end_year))
  
  if (nrow(region_data) != 2) {
    stop("Could not find data for both years in the specified region")
  }
  
  # Calculate percentage change
  start_value <- region_data[[metric]][region_data$year == start_year]
  end_value <- region_data[[metric]][region_data$year == end_year]
  
  pct_change <- ((end_value - start_value) / start_value) * 100
  
  return(round(pct_change, 2))
}


#' Plot FFDI Trend
#'
#' Creates a time series plot of the Forest Fire Danger Index for one or more regions.
#'
#' @param data Data frame containing bushfire data
#' @param regions Character vector of region names to plot
#' @param add_trend Logical. If TRUE (default), adds a trend line
#' @param interactive Logical. If TRUE, creates an interactive plotly chart.
#'   If FALSE (default), creates a static ggplot2 chart.
#'
#' @return A ggplot2 or plotly object
#'
#' @examples
#' \dontrun{
#' # Plot single region
#' plot_ffdi_trend(bushfire_data, "Southeast Australia")
#'
#' # Compare multiple regions
#' plot_ffdi_trend(bushfire_data, 
#'                c("Southeast Australia", "Eastern Australia"))
#'
#' # Create interactive plot
#' plot_ffdi_trend(bushfire_data, "Southeast Australia", interactive = TRUE)
#' }
#'
#' @export
#' @importFrom ggplot2 ggplot aes geom_line geom_smooth labs theme_minimal
#' @importFrom dplyr filter
plot_ffdi_trend <- function(data, regions, add_trend = TRUE, 
                           interactive = FALSE) {
  
  # Filter data
  plot_data <- data %>%
    dplyr::filter(region %in% regions)
  
  if (nrow(plot_data) == 0) {
    stop("No data found for the specified region(s)")
  }
  
  # Create base plot
  p <- ggplot2::ggplot(plot_data, 
                       ggplot2::aes(x = year, y = ffdi_mean, 
                                   color = region, group = region)) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::labs(
      title = "Forest Fire Danger Index Trends",
      x = "Year",
      y = "Mean FFDI",
      color = "Region"
    ) +
    ggplot2::theme_minimal()
  
  # Add trend line if requested
  if (add_trend) {
    p <- p + ggplot2::geom_smooth(method = "lm", se = TRUE, alpha = 0.2)
  }
  
  # Make interactive if requested
  if (interactive) {
    if (!requireNamespace("plotly", quietly = TRUE)) {
      warning("plotly package not available. Returning static plot.")
      return(p)
    }
    p <- plotly::ggplotly(p)
  }
  
  return(p)
}


#' Compare Regions
#'
#' Creates a comparison summary of bushfire risk metrics across regions.
#'
#' @param data Data frame containing bushfire data
#' @param year_range Numeric vector of length 2 specifying the year range
#'
#' @return A data frame with summary statistics by region
#'
#' @examples
#' \dontrun{
#' # Compare all regions for recent decades
#' compare_regions(bushfire_data, year_range = c(2000, 2020))
#'
#' # Full historical comparison
#' compare_regions(bushfire_data, year_range = c(1950, 2020))
#' }
#'
#' @export
#' @importFrom dplyr filter group_by summarise arrange desc
compare_regions <- function(data, year_range = c(1950, 2020)) {
  
  data %>%
    dplyr::filter(year >= year_range[1], year <= year_range[2]) %>%
    dplyr::group_by(region) %>%
    dplyr::summarise(
      mean_ffdi = mean(ffdi_mean, na.rm = TRUE),
      mean_extreme_days = mean(extreme_days, na.rm = TRUE),
      total_area_burned = sum(area_burned_1000ha, na.rm = TRUE),
      max_ffdi = max(ffdi_mean, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    dplyr::arrange(dplyr::desc(mean_ffdi))
}


#' Format Risk Level
#'
#' Converts numeric FFDI values to categorical risk levels.
#'
#' @param ffdi Numeric vector of FFDI values
#'
#' @return Character vector of risk levels
#'
#' @details
#' Risk levels are defined as:
#' \itemize{
#'   \item Low: FFDI < 12
#'   \item Moderate: 12 <= FFDI < 24
#'   \item High: 24 <= FFDI < 50
#'   \item Very High: 50 <= FFDI < 75
#'   \item Extreme: FFDI >= 75
#' }
#'
#' @examples
#' format_risk_level(c(8, 15, 30, 60, 80))
#'
#' @export
format_risk_level <- function(ffdi) {
  dplyr::case_when(
    ffdi < 12 ~ "Low",
    ffdi < 24 ~ "Moderate",
    ffdi < 50 ~ "High",
    ffdi < 75 ~ "Very High",
    TRUE ~ "Extreme"
  )
}
