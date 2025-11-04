# Bushfire Risk Explorer - Server
library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(DT)
library(scales)

# Define server logic
server <- function(input, output, session) {
  
  # Load data
  data("bushfire_data", package = "bushfireRisk", envir = environment())
  data("climate_attribution", package = "bushfireRisk", envir = environment())
  data("regional_summary", package = "bushfireRisk", envir = environment())
  
  # Reactive filtered data
  filtered_data <- reactive({
    req(input$region_select, input$year_range)
    
    bushfire_data %>%
      filter(
        region %in% input$region_select,
        year >= input$year_range[1],
        year <= input$year_range[2]
      )
  })
  
  # Overview Tab Outputs
  output$total_regions <- renderValueBox({
    valueBox(
      value = 5,
      subtitle = "Australian Regions",
      icon = icon("map"),
      color = "blue"
    )
  })
  
  output$year_span <- renderValueBox({
    valueBox(
      value = "1950-2020",
      subtitle = "Data Time Span",
      icon = icon("calendar"),
      color = "green"
    )
  })
  
  output$highest_risk <- renderValueBox({
    valueBox(
      value = "Southeast",
      subtitle = "Highest Risk Region",
      icon = icon("fire"),
      color = "red"
    )
  })
  
  output$confidence <- renderValueBox({
    valueBox(
      value = "95%",
      subtitle = "Attribution Confidence",
      icon = icon("check-circle"),
      color = "orange"
    )
  })
  
  output$overview_plot <- renderPlotly({
    p <- ggplot(bushfire_data, aes(x = year, y = ffdi_mean, color = region)) +
      geom_line(linewidth = 0.8) +
      labs(
        x = "Year",
        y = "Mean FFDI",
        color = "Region"
      ) +
      theme_minimal() +
      theme(legend.position = "bottom")
    
    ggplotly(p, tooltip = c("x", "y", "color")) %>%
      layout(legend = list(orientation = "h", y = -0.2))
  })
  
  output$regional_bars <- renderPlotly({
    summary_data <- bushfire_data %>%
      filter(year >= 2000) %>%
      group_by(region) %>%
      summarise(mean_ffdi = mean(ffdi_mean, na.rm = TRUE)) %>%
      arrange(desc(mean_ffdi))
    
    p <- ggplot(summary_data, aes(x = reorder(region, mean_ffdi), y = mean_ffdi, 
                                   fill = mean_ffdi)) +
      geom_col() +
      coord_flip() +
      scale_fill_gradient(low = "#fee5d9", high = "#a50f15") +
      labs(
        x = NULL,
        y = "Mean FFDI (2000-2020)"
      ) +
      theme_minimal() +
      theme(legend.position = "none")
    
    ggplotly(p, tooltip = c("y"))
  })
  
  # Regional Analysis Tab
  output$regional_plot <- renderPlotly({
    req(input$region_select)
    
    data <- filtered_data()
    
    p <- ggplot(data, aes(x = year, y = ffdi_mean, color = region)) +
      geom_line(linewidth = 1) +
      labs(
        x = "Year",
        y = "Forest Fire Danger Index",
        color = "Region"
      ) +
      theme_minimal() +
      theme(
        legend.position = "bottom",
        plot.title = element_text(size = 14, face = "bold")
      )
    
    if (input$show_trend) {
      p <- p + geom_smooth(method = "lm", se = TRUE, alpha = 0.2, linewidth = 0.8)
    }
    
    ggplotly(p, tooltip = c("x", "y", "color")) %>%
      layout(
        legend = list(orientation = "h", y = -0.15),
        hovermode = "x unified"
      )
  })
  
  output$regional_table <- renderDT({
    data <- filtered_data() %>%
      group_by(region) %>%
      summarise(
        `Mean FFDI` = round(mean(ffdi_mean, na.rm = TRUE), 2),
        `Max FFDI` = round(max(ffdi_mean, na.rm = TRUE), 2),
        `Avg Extreme Days` = round(mean(extreme_days, na.rm = TRUE), 1),
        `Total Area Burned (1000 ha)` = round(sum(area_burned_1000ha, na.rm = TRUE), 0)
      )
    
    datatable(
      data,
      options = list(
        pageLength = 10,
        dom = 't',
        ordering = TRUE
      ),
      rownames = FALSE
    ) %>%
      formatStyle(
        'Mean FFDI',
        backgroundColor = styleInterval(c(15, 20, 25), 
                                        c('#fee5d9', '#fcae91', '#fb6a4a', '#de2d26'))
      )
  })
  
  output$risk_change_ui <- renderUI({
    req(input$region_select)
    
    results <- lapply(input$region_select, function(reg) {
      change <- tryCatch({
        start_val <- filtered_data() %>%
          filter(region == reg, year == input$year_range[1]) %>%
          pull(ffdi_mean)
        
        end_val <- filtered_data() %>%
          filter(region == reg, year == input$year_range[2]) %>%
          pull(ffdi_mean)
        
        if (length(start_val) > 0 && length(end_val) > 0) {
          pct <- round(((end_val - start_val) / start_val) * 100, 1)
          paste0(reg, ": ", ifelse(pct > 0, "+", ""), pct, "%")
        } else {
          NULL
        }
      }, error = function(e) NULL)
    })
    
    results <- results[!sapply(results, is.null)]
    
    if (length(results) > 0) {
      HTML(paste0(
        "<div style='padding: 15px; font-size: 16px;'>",
        "<h4>FFDI Change (", input$year_range[1], " to ", input$year_range[2], "):</h4>",
        "<ul style='line-height: 2;'>",
        paste0("<li><strong>", results, "</strong></li>", collapse = ""),
        "</ul>",
        "<hr>",
        "<p style='font-size: 13px; color: #7f8c8d;'>",
        "Positive values indicate increased fire danger. ",
        "Southeast Australia consistently shows the highest increases.",
        "</p>",
        "</div>"
      ))
    } else {
      HTML("<p>No data available for selected years.</p>")
    }
  })
  
  # Trends Tab
  output$trend_plot <- renderPlotly({
    data <- filtered_data()
    
    p <- ggplot(data, aes(x = year, y = ffdi_mean, color = region)) +
      geom_point(alpha = 0.5, size = 2) +
      geom_smooth(method = "lm", se = TRUE, linewidth = 1.2) +
      labs(
        x = "Year",
        y = "Forest Fire Danger Index",
        color = "Region"
      ) +
      theme_minimal() +
      theme(legend.position = "bottom")
    
    ggplotly(p, tooltip = c("x", "y", "color")) %>%
      layout(legend = list(orientation = "h", y = -0.15))
  })
  
  output$trend_summary <- renderUI({
    req(input$region_select)
    
    trends <- lapply(input$region_select, function(reg) {
      data <- filtered_data() %>% filter(region == reg)
      
      if (nrow(data) > 2) {
        model <- lm(ffdi_mean ~ year, data = data)
        slope <- coef(model)[2]
        r_squared <- summary(model)$r.squared
        
        list(
          region = reg,
          slope = round(slope, 3),
          r2 = round(r_squared, 3)
        )
      } else {
        NULL
      }
    })
    
    trends <- trends[!sapply(trends, is.null)]
    
    if (length(trends) > 0) {
      trend_text <- sapply(trends, function(t) {
        paste0(
          "<li><strong>", t$region, ":</strong><br>",
          "Trend: ", ifelse(t$slope > 0, "+", ""), t$slope, " FFDI/year<br>",
          "R² = ", t$r2,
          "</li>"
        )
      })
      
      HTML(paste0(
        "<div style='padding: 10px; font-size: 14px;'>",
        "<h4>Linear Trends:</h4>",
        "<ul style='line-height: 2.2;'>",
        paste(trend_text, collapse = ""),
        "</ul>",
        "<hr style='margin: 15px 0;'>",
        "<p style='font-size: 12px; color: #7f8c8d;'>",
        "R² indicates how well the linear model fits the data. ",
        "Positive slopes show increasing fire danger.",
        "</p>",
        "</div>"
      ))
    }
  })
  
  output$extreme_days_plot <- renderPlotly({
    data <- filtered_data()
    
    p <- ggplot(data, aes(x = year, y = extreme_days, color = region)) +
      geom_line(linewidth = 1) +
      geom_point(alpha = 0.5) +
      labs(
        x = "Year",
        y = "Number of Extreme Fire Days",
        color = "Region"
      ) +
      theme_minimal() +
      theme(legend.position = "bottom")
    
    ggplotly(p, tooltip = c("x", "y", "color")) %>%
      layout(legend = list(orientation = "h", y = -0.15))
  })
  
  output$area_burned_plot <- renderPlotly({
    data <- filtered_data()
    
    p <- ggplot(data, aes(x = year, y = area_burned_1000ha, color = region)) +
      geom_col(alpha = 0.7) +
      labs(
        x = "Year",
        y = "Area Burned (1000 ha)",
        fill = "Region"
      ) +
      theme_minimal() +
      theme(legend.position = "bottom")
    
    ggplotly(p, tooltip = c("x", "y", "color")) %>%
      layout(legend = list(orientation = "h", y = -0.15))
  })
  
  # Attribution Tab
  output$attribution_plot <- renderPlotly({
    p <- ggplot(climate_attribution, aes(x = year, y = ffdi_mean, 
                                         color = scenario, linetype = scenario)) +
      geom_line(linewidth = 1.2) +
      geom_ribbon(aes(ymin = ffdi_mean - 1, ymax = ffdi_mean + 1, fill = scenario),
                  alpha = 0.2, color = NA) +
      labs(
        x = "Year",
        y = "Forest Fire Danger Index",
        color = "Climate Scenario",
        linetype = "Climate Scenario",
        fill = "Climate Scenario"
      ) +
      scale_color_manual(values = c("Natural Climate" = "#2c7bb6", 
                                    "Anthropogenic Climate" = "#d7191c")) +
      scale_fill_manual(values = c("Natural Climate" = "#2c7bb6", 
                                   "Anthropogenic Climate" = "#d7191c")) +
      theme_minimal() +
      theme(legend.position = "bottom")
    
    ggplotly(p, tooltip = c("x", "y", "color")) %>%
      layout(legend = list(orientation = "h", y = -0.2))
  })
  
  output$attribution_box1 <- renderInfoBox({
    infoBox(
      title = "Risk Increase",
      value = "+30%",
      subtitle = "Extreme events more likely",
      icon = icon("arrow-up"),
      color = "red",
      fill = TRUE
    )
  })
  
  output$attribution_box2 <- renderInfoBox({
    infoBox(
      title = "Southeast Australia",
      value = "95%",
      subtitle = "Attribution confidence",
      icon = icon("check-circle"),
      color = "orange",
      fill = TRUE
    )
  })
  
  output$attribution_box3 <- renderInfoBox({
    natural <- climate_attribution %>%
      filter(scenario == "Natural Climate", year == 2020) %>%
      pull(ffdi_mean)
    
    anthro <- climate_attribution %>%
      filter(scenario == "Anthropogenic Climate", year == 2020) %>%
      pull(ffdi_mean)
    
    diff <- round(anthro - natural, 1)
    
    infoBox(
      title = "FFDI Difference (2020)",
      value = paste0("+", diff),
      subtitle = "Anthropogenic vs Natural",
      icon = icon("fire"),
      color = "red",
      fill = TRUE
    )
  })
  
  # Data Explorer Tab
  output$data_table <- renderDT({
    datatable(
      bushfire_data,
      options = list(
        pageLength = 25,
        scrollX = TRUE,
        order = list(list(0, 'desc'))
      ),
      filter = 'top',
      rownames = FALSE
    ) %>%
      formatRound(columns = c('ffdi_mean', 'area_burned_1000ha'), digits = 2) %>%
      formatStyle(
        'ffdi_mean',
        backgroundColor = styleInterval(
          c(10, 15, 20, 25),
          c('#ffffff', '#fee5d9', '#fcae91', '#fb6a4a', '#de2d26')
        )
      )
  })
  
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("bushfire_data_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(bushfire_data, file, row.names = FALSE)
    }
  )
}
