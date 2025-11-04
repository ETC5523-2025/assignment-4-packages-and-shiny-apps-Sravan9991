# bushfireRisk 0.1.0

## Initial Release

### Features

* Interactive Shiny dashboard for exploring bushfire risk data
* Three comprehensive datasets:
  - `bushfire_data`: Regional fire danger metrics 1950-2020
  - `climate_attribution`: Natural vs anthropogenic climate scenarios
  - `regional_summary`: Summary statistics by region
* Analysis functions:
  - `launch_bushfire_app()`: Launch interactive dashboard
  - `calculate_risk_change()`: Calculate percentage change in fire risk
  - `plot_ffdi_trend()`: Visualize Fire Danger Index trends
  - `compare_regions()`: Compare fire risk across regions
  - `format_risk_level()`: Convert FFDI to categorical risk levels
* Comprehensive documentation and vignettes
* pkgdown website

### Data

* Based on Oldenborgh et al. (2021) climate attribution research
* Covers all major Australian regions
* 71 years of historical data (1950-2020)

### Documentation

* Introduction vignette
* Climate attribution science vignette  
* Detailed function documentation
* README with quick start guide
