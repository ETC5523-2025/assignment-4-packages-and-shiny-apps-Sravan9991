#' Launch the Netflix Explorer Shiny App
#'
#' This function launches the interactive Shiny app that allows users to
#' explore the Netflix data included with the package.
#'
#' @export
run_app <- function() {
  app_dir <- system.file("shiny-app", package = "netflixExplorer")
  if (app_dir == "") {
    stop("Could not find the Shiny app directory. Try reinstalling the package.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
