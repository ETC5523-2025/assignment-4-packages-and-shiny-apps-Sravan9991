#' Australian Bushfire Risk Data
#'
#' A dataset containing annual bushfire risk metrics for Australian regions
#' from 1950 to 2020. Data is based on attribution studies showing how
#' anthropogenic climate change has increased fire danger.
#'
#' @format A data frame with 355 rows and 6 variables:
#' \describe{
#'   \item{year}{Numeric. Year of observation (1950-2020)}
#'   \item{region}{Character. Australian region name. One of: "Southeast Australia",
#'     "Eastern Australia", "Southern Australia", "Northern Australia",
#'     "Western Australia"}
#'   \item{ffdi_mean}{Numeric. Mean Forest Fire Danger Index for the year.
#'     Higher values indicate more dangerous fire conditions}
#'   \item{extreme_days}{Numeric. Number of days with extreme fire danger (FFDI > 50)}
#'   \item{area_burned_1000ha}{Numeric. Total area burned in thousands of hectares}
#'   \item{attribution_confidence}{Numeric. Percentage confidence that observed
#'     trends are attributable to anthropogenic climate change (range: 75-95)}
#' }
#'
#' @details
#' The Forest Fire Danger Index (FFDI) is calculated from temperature, humidity,
#' wind speed, and drought conditions. Values above 50 indicate "extreme" fire danger.
#'
#' This dataset shows that:
#' \itemize{
#'   \item Southeast Australia has experienced the strongest increase in fire risk
#'   \item Human-caused climate change has made extreme fire weather more common
#'   \item Fire danger has increased most rapidly since 1980
#'   \item The 2019-2020 "Black Summer" saw unprecedented fire activity
#' }
#'
#' @source
#' Based on research by Oldenborgh, G.J., Philip, S.Y., Kew, S.F., van der Wiel, K.,
#' et al. (2021). Attribution of the Australian bushfire risk to anthropogenic
#' climate change. Environmental Research Letters.
#'
#' @examples
#' data(bushfire_data)
#' head(bushfire_data)
#'
#' # Summary by region
#' library(dplyr)
#' bushfire_data %>%
#'   group_by(region) %>%
#'   summarise(mean_ffdi = mean(ffdi_mean))
"bushfire_data"


#' Climate Attribution Comparison Data
#'
#' A dataset comparing fire danger under natural climate variability versus
#' anthropogenic climate change scenarios.
#'
#' @format A data frame with 142 rows and 4 variables:
#' \describe{
#'   \item{scenario}{Character. Either "Natural Climate" or "Anthropogenic Climate"}
#'   \item{year}{Numeric. Year of observation (1950-2020)}
#'   \item{ffdi_mean}{Numeric. Mean Forest Fire Danger Index}
#'   \item{extreme_probability}{Numeric. Probability of extreme fire events (0-1)}
#' }
#'
#' @details
#' This dataset shows the difference between:
#' \itemize{
#'   \item Natural Climate: Fire risk with only natural climate drivers
#'     (solar variability, volcanic activity)
#'   \item Anthropogenic Climate: Fire risk including human-caused greenhouse
#'     gas emissions
#' }
#'
#' The divergence between scenarios demonstrates the attribution of increased
#' fire risk to human activities.
#'
#' @source
#' Based on climate model simulations from Oldenborgh et al. (2021)
#'
#' @examples
#' data(climate_attribution)
#'
#' # Compare scenarios
#' library(ggplot2)
#' ggplot(climate_attribution, aes(x = year, y = ffdi_mean, color = scenario)) +
#'   geom_line() +
#'   labs(title = "Natural vs Anthropogenic Climate Influence on Fire Risk")
"climate_attribution"


#' Regional Summary Statistics
#'
#' Summary statistics of bushfire risk by Australian region across the full
#' 1950-2020 time period.
#'
#' @format A data frame with 5 rows and 7 variables:
#' \describe{
#'   \item{region}{Character. Region name}
#'   \item{mean_ffdi}{Numeric. Average FFDI across all years}
#'   \item{max_ffdi}{Numeric. Maximum FFDI observed}
#'   \item{total_area_burned}{Numeric. Total area burned 1950-2020 (thousands of ha)}
#'   \item{avg_extreme_days}{Numeric. Average number of extreme fire danger days per year}
#'   \item{trend_coefficient}{Numeric. Linear trend coefficient (FFDI per year)}
#'   \item{attribution_confidence}{Numeric. Confidence in climate change attribution (%)}
#' }
#'
#' @details
#' Regions are ordered by mean fire danger, with Southeast Australia showing
#' the highest risk and strongest upward trend.
#'
#' @source
#' Calculated from bushfire_data
#'
#' @examples
#' data(regional_summary)
#' regional_summary
"regional_summary"
