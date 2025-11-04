# Bushfire Risk Explorer - UI
library(shiny)
library(shinydashboard)
library(plotly)
library(DT)

# Define the UI
ui <- dashboardPage(
  skin = "red",
  
  # Header
  dashboardHeader(
    title = "Bushfire Risk Explorer",
    titleWidth = 300
  ),
  
  # Sidebar
  dashboardSidebar(
    width = 300,
    sidebarMenu(
      id = "tabs",
      menuItem("Overview", tabName = "overview", icon = icon("home")),
      menuItem("Regional Analysis", tabName = "regional", icon = icon("map")),
      menuItem("Time Trends", tabName = "trends", icon = icon("chart-line")),
      menuItem("Attribution", tabName = "attribution", icon = icon("fire")),
      menuItem("Data Explorer", tabName = "data", icon = icon("table")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    ),
    
    hr(),
    
    # Conditional panels for different tabs
    conditionalPanel(
      condition = "input.tabs == 'regional' || input.tabs == 'trends'",
      h4("Filter Options", style = "padding-left: 15px;"),
      
      selectInput(
        "region_select",
        "Select Region(s):",
        choices = c("Southeast Australia", "Eastern Australia", 
                   "Southern Australia", "Northern Australia", 
                   "Western Australia"),
        selected = "Southeast Australia",
        multiple = TRUE
      ),
      
      sliderInput(
        "year_range",
        "Year Range:",
        min = 1950,
        max = 2020,
        value = c(1950, 2020),
        step = 1,
        sep = ""
      ),
      
      checkboxInput(
        "show_trend",
        "Show trend line",
        value = TRUE
      )
    ),
    
    conditionalPanel(
      condition = "input.tabs == 'data'",
      h4("Data Export", style = "padding-left: 15px;"),
      downloadButton("download_data", "Download CSV", 
                    style = "margin-left: 15px; margin-top: 10px;")
    ),
    
    hr(),
    div(
      style = "padding: 15px; font-size: 11px; color: #7f8c8d;",
      "Data source: Oldenborgh et al. (2021)",
      br(),
      "Package: bushfireRisk v0.1.0"
    )
  ),
  
  # Body
  dashboardBody(
    # Custom CSS
    tags$head(
      tags$style(HTML("
        .content-wrapper { background-color: #ecf0f1; }
        .box { border-top: 3px solid #e74c3c; }
        .small-box { border-radius: 5px; }
        .info-box { border-radius: 5px; }
        .nav-tabs-custom { border-radius: 5px; }
        h3 { color: #2c3e50; }
        .help-text { 
          background-color: #fff3cd; 
          padding: 15px; 
          border-left: 4px solid #ffc107;
          border-radius: 4px;
          margin-bottom: 20px;
        }
      "))
    ),
    
    tabItems(
      # Overview Tab
      tabItem(
        tabName = "overview",
        h2("Australian Bushfire Risk Attribution to Climate Change"),
        
        fluidRow(
          box(
            width = 12,
            title = "Key Findings",
            status = "danger",
            solidHeader = TRUE,
            HTML("
              <p style='font-size: 16px; line-height: 1.6;'>
              This dashboard explores how <strong>human-caused climate change</strong> 
              has increased bushfire risk in Australia, based on research by 
              Oldenborgh et al. (2021).
              </p>
              <hr>
              <h4>Main Results:</h4>
              <ul style='font-size: 15px; line-height: 1.8;'>
                <li><strong>Southeast Australia</strong> shows the strongest increase 
                in fire risk</li>
                <li>Extreme fire weather is now <strong>30% more likely</strong> due 
                to human-caused warming</li>
                <li>The Forest Fire Danger Index (FFDI) has increased significantly 
                since 1980</li>
                <li>Without emission reductions, catastrophic fire seasons will become 
                more frequent</li>
              </ul>
            ")
          )
        ),
        
        fluidRow(
          valueBoxOutput("total_regions", width = 3),
          valueBoxOutput("year_span", width = 3),
          valueBoxOutput("highest_risk", width = 3),
          valueBoxOutput("confidence", width = 3)
        ),
        
        fluidRow(
          box(
            width = 6,
            title = "FFDI Trends by Region",
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("overview_plot", height = 350)
          ),
          box(
            width = 6,
            title = "Regional Risk Comparison",
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("regional_bars", height = 350)
          )
        )
      ),
      
      # Regional Analysis Tab
      tabItem(
        tabName = "regional",
        h2("Regional Fire Danger Analysis"),
        
        fluidRow(
          box(
            width = 12,
            div(
              class = "help-text",
              icon("lightbulb"), " ", 
              strong("How to use:"), 
              " Select one or more regions from the sidebar to compare their fire 
              danger trends. The chart shows the mean Forest Fire Danger Index (FFDI) 
              over time. Higher FFDI values indicate more dangerous fire conditions."
            )
          )
        ),
        
        fluidRow(
          box(
            width = 12,
            title = "Fire Danger Index Over Time",
            status = "danger",
            solidHeader = TRUE,
            plotlyOutput("regional_plot", height = 450)
          )
        ),
        
        fluidRow(
          box(
            width = 6,
            title = "Summary Statistics",
            status = "info",
            solidHeader = TRUE,
            DTOutput("regional_table")
          ),
          box(
            width = 6,
            title = "Risk Change Analysis",
            status = "info",
            solidHeader = TRUE,
            uiOutput("risk_change_ui")
          )
        )
      ),
      
      # Trends Tab
      tabItem(
        tabName = "trends",
        h2("Long-term Fire Risk Trends"),
        
        fluidRow(
          box(
            width = 12,
            div(
              class = "help-text",
              icon("info-circle"), " ",
              strong("Understanding the trends:"),
              " These visualizations show how fire risk has changed over time. 
              The trend lines reveal the statistical relationship between year and 
              fire danger, with confidence intervals showing the uncertainty."
            )
          )
        ),
        
        fluidRow(
          box(
            width = 8,
            title = "FFDI Temporal Trends",
            status = "warning",
            solidHeader = TRUE,
            plotlyOutput("trend_plot", height = 400)
          ),
          box(
            width = 4,
            title = "Trend Summary",
            status = "warning",
            solidHeader = TRUE,
            uiOutput("trend_summary")
          )
        ),
        
        fluidRow(
          box(
            width = 6,
            title = "Extreme Fire Days",
            status = "danger",
            solidHeader = TRUE,
            plotlyOutput("extreme_days_plot", height = 350)
          ),
          box(
            width = 6,
            title = "Area Burned",
            status = "danger",
            solidHeader = TRUE,
            plotlyOutput("area_burned_plot", height = 350)
          )
        )
      ),
      
      # Attribution Tab
      tabItem(
        tabName = "attribution",
        h2("Climate Change Attribution Analysis"),
        
        fluidRow(
          box(
            width = 12,
            div(
              class = "help-text",
              icon("question-circle"), " ",
              strong("What is attribution science?"),
              " Attribution studies compare what actually happened (with human-caused 
              climate change) to what would have happened in a world with only natural 
              climate drivers. The difference reveals human influence."
            )
          )
        ),
        
        fluidRow(
          box(
            width = 12,
            title = "Natural vs Anthropogenic Climate Influence",
            status = "danger",
            solidHeader = TRUE,
            plotlyOutput("attribution_plot", height = 450),
            hr(),
            p(
              style = "font-size: 14px; padding: 10px;",
              strong("Interpretation:"),
              " The gap between the two lines shows the additional fire risk 
              caused by human greenhouse gas emissions. Southeast Australia shows 
              the clearest signal of anthropogenic influence, with 95% confidence 
              that observed trends exceed natural variability."
            )
          )
        ),
        
        fluidRow(
          infoBoxOutput("attribution_box1", width = 4),
          infoBoxOutput("attribution_box2", width = 4),
          infoBoxOutput("attribution_box3", width = 4)
        )
      ),
      
      # Data Explorer Tab
      tabItem(
        tabName = "data",
        h2("Data Explorer"),
        
        fluidRow(
          box(
            width = 12,
            div(
              class = "help-text",
              icon("database"), " ",
              strong("Explore the data:"),
              " This table shows all the raw data used in this dashboard. 
              You can search, sort, and filter the data. Use the download button 
              in the sidebar to export as CSV."
            )
          )
        ),
        
        fluidRow(
          box(
            width = 12,
            title = "Complete Dataset",
            status = "primary",
            solidHeader = TRUE,
            DTOutput("data_table")
          )
        )
      ),
      
      # About Tab
      tabItem(
        tabName = "about",
        h2("About This Dashboard"),
        
        fluidRow(
          box(
            width = 12,
            title = "Research Background",
            status = "info",
            solidHeader = TRUE,
            HTML("
              <h4>Attribution of Australian Bushfire Risk to Climate Change</h4>
              <p style='font-size: 15px; line-height: 1.8;'>
              This dashboard is based on research by <strong>Oldenborgh et al. (2021)</strong> 
              published in <em>Environmental Research Letters</em>. The study used:
              </p>
              <ul style='font-size: 14px; line-height: 1.6;'>
                <li>Observed climate records from the Australian Bureau of Meteorology</li>
                <li>Climate model simulations comparing scenarios with and without 
                human influence</li>
                <li>The Forest Fire Danger Index (FFDI) as the primary metric</li>
              </ul>
              
              <hr>
              
              <h4>Key Metrics Explained</h4>
              <dl style='font-size: 14px; line-height: 1.6;'>
                <dt><strong>Forest Fire Danger Index (FFDI)</strong></dt>
                <dd>A composite measure combining temperature, humidity, wind speed, 
                and drought conditions. Values above 50 indicate 'extreme' fire danger, 
                above 75 is 'catastrophic'.</dd>
                
                <dt><strong>Extreme Fire Days</strong></dt>
                <dd>Number of days per year with FFDI exceeding 50 (extreme threshold).</dd>
                
                <dt><strong>Attribution Confidence</strong></dt>
                <dd>Statistical confidence that observed trends exceed natural climate 
                variability and are attributable to human-caused warming.</dd>
              </dl>
              
              <hr>
              
              <h4>Data Sources</h4>
              <p style='font-size: 14px;'>
              <strong>Primary Citation:</strong><br>
              Oldenborgh, G.J., Philip, S.Y., Kew, S.F., van der Wiel, K., et al. (2021). 
              Attribution of the Australian bushfire risk to anthropogenic climate change. 
              <em>Environmental Research Letters</em>.
              </p>
              
              <hr>
              
              <h4>Package Information</h4>
              <p style='font-size: 14px;'>
              <strong>Package:</strong> bushfireRisk v0.1.0<br>
              <strong>Author:</strong> Sravan Kumar Kapu Bejjala<br>
              <strong>License:</strong> MIT<br>
              <strong>GitHub:</strong> 
              <a href='https://github.com/ETC5523-2025/assignment-4-packages-Sravan9991'>
              Repository Link</a>
              </p>
            ")
          )
        )
      )
    )
  )
)
