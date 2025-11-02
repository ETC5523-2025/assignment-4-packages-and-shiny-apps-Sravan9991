library(ggplot2)
library(dplyr)
library(netflixExplorer)
library(shiny)

# UI
ui <- fluidPage(
  titlePanel("Netflix Explorer App"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "type", "Select Content Type:",
        choices = c("All", unique(netflix_clean$type))
      )
    ),
    mainPanel(
      plotOutput("yearPlot"),
      tableOutput("table")
    )
  )
)

# Server
server <- function(input, output) {

  data("netflix_clean", package = "netflixExplorer")

  filtered_data <- reactive({
    req(input$type)
    if (input$type == "All") return(netflix_clean)
    netflix_clean %>% filter(type == input$type)
  })

  output$yearPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = as.factor(release_year))) +
      geom_bar(fill = "skyblue") +
      labs(
        title = paste("Count by Year:", input$type),
        x = "Year", y = "Count"
      ) +
      theme_minimal()
  })

  output$table <- renderTable({
    head(filtered_data(), 10)
  })
}

# Run the app
shinyApp(ui, server)
