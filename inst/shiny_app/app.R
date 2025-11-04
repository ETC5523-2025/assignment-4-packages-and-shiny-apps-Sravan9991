# Main Shiny App File
# This file sources the UI and server components and launches the app

# Source UI and server
source("ui.R")
source("server.R")

# Run the app
shinyApp(ui = ui, server = server)
