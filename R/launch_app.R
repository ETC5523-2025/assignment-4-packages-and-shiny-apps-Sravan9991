#' Launch Bushfire Risk Explorer Shiny App
#'
#' This function launches an interactive Shiny application for exploring
#' Australian bushfire risk data and the attribution to anthropogenic climate change.
#'
#' @details
#' The app provides several features:
#' \itemize{
#'   \item Regional comparison of fire danger trends
#'   \item Time series visualization of Forest Fire Danger Index (FFDI)
#'   \item Climate attribution analysis
#'   \item Interactive data filtering and exploration
#'   \item Data export functionality
#' }
#'
#' The application uses data from Oldenborgh et al. (2021) showing how
#' human-caused climate change has increased bushfire risk in Australia,
#' particularly in the southeast region.
#'
#' @param launch.browser Logical. If TRUE (default), opens the app in your
#'   default web browser. Set to FALSE to run in RStudio Viewer pane.
#' @param display.mode Character. Display mode for the app. Options are
#'   "normal" (default), "showcase". Showcase mode displays the app code
#'   alongside the running application.
#'
#' @return No return value. Launches the Shiny application.
#'
#' @examples
#' \dontrun{
#' # Launch the app in browser
#' launch_bushfire_app()
#'
#' # Launch in RStudio viewer
#' launch_bushfire_app(launch.browser = FALSE)
#'
#' # Launch in showcase mode
#' launch_bushfire_app(display.mode = "showcase")
#' }
#'
#' @export
#' @importFrom shiny runApp
launch_bushfire_app <- function(launch.browser = TRUE, 
                                display.mode = "normal") {
  
  # Get the app directory
  app_dir <- system.file("shiny_app", package = "bushfireRisk")
  
  # Check if app directory exists
  if (app_dir == "") {
    stop(
      "Could not find Shiny app directory. ",
      "Try re-installing the bushfireRisk package.",
      call. = FALSE
    )
  }
  
  # Launch the app
  shiny::runApp(
    appDir = app_dir,
    launch.browser = launch.browser,
    display.mode = display.mode
  )
}
