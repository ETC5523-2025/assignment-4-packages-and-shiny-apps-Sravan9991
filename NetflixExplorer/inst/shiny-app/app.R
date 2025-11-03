# =====================================================
# Netflix Explorer Shiny App
# Optimized for speed and packaged version
# =====================================================

library(shiny)
library(ggplot2)
library(dplyr)
library(netflixExplorer)

# -----------------------------------------------------
# Load the dataset once when the app starts
# -----------------------------------------------------
data("netflix_clean", package = "netflixExplorer")

# Optional: work on a smaller sample for speed
# (remove this if your dataset is already small)
sample_data <- netflix_clean %>% sample_n(min(2000, nrow(netflix_clean)))

# -----------------------------------------------------
# Precompute summary tables to avoid recalculating in reactivity
# -----------------------------------------------------
summary_year <- sample_data %>%
  count(release_year, type)

summary_type <- sample_data %>%
  count(type)

# -----------------------------------------------------
# Define UI
# -----------------------------------------------------
ui <- fluidPage(
  titlePanel("🎬 Netflix Explorer App"),

  sidebarLayout(
    sidebarPanel(
      helpText("Explore Netflix titles by type and release year."),
      selectInput(
        "type",
        "Select Content Type:",
        choices = c("All", levels(sample_data$type))
      ),
      helpText("Select a type to filter results and update plots.")
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Plot by Year", plotOutput("yearPlot")),
        tabPanel("Data Table", tableOutput("table"))
      )
    )
  )
)

# -----------------------------------------------------
# Define Server
# -----------------------------------------------------
server <- function(input, output) {

  # Reactive dataset filtered by content type
  filtered_data <- reactive({
    req(input$type)
    if (input$type == "All") return(sample_data)
    sample_data %>% filter(type == input$type)
  })

  # Reactive summary table filtered by type for plotting
  filtered_summary <- reactive({
    if (input$type == "All") return(summary_year)
    summary_year %>% filter(type == input$type)
  })

  # -----------------------------------------------------
  # Plot: Count by Year
  # -----------------------------------------------------
  output$yearPlot <- renderPlot({
    ggplot(filtered_summary(), aes(x = as.factor(release_year), y = n)) +
      geom_col(fill = "steelblue") +
      labs(
        title = paste("Number of Netflix Titles by Year:", input$type),
        x = "Release Year",
        y = "Count"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
  })

  # -----------------------------------------------------
  # Table: Preview filtered data
  # -----------------------------------------------------
  output$table <- renderTable({
    head(filtered_data(), 10)
  })
}

# -----------------------------------------------------
# Run the Shiny App
# -----------------------------------------------------
shinyApp(ui = ui, server = server)
